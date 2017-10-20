// **********************************************************************
//
// Copyright (c) 2003-2017 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#pragma once

#include <DataStorm/Sample.ice>

module DataStormContract
{

/** A sequence of bytes use to hold the encoded key or value */
sequence<byte> ByteSeq;

/** A sequence of long */
sequence<long> LongSeq;

struct DataSample
{
    long id;
    long timestamp;
    DataStorm::SampleType type;
    ByteSeq value;
}
sequence<DataSample> DataSampleSeq;

struct DataSamples
{
    long id;
    DataSampleSeq samples;
}
sequence<DataSamples> DataSamplesSeq;

struct ElementInfo
{
    long valueId;
    ByteSeq value;
}
sequence<ElementInfo> ElementInfoSeq;

struct TopicInfo
{
    string name;
    LongSeq ids;
}
sequence<TopicInfo> TopicInfoSeq;

struct TopicSpec
{
    long id;
    string name;
    ElementInfoSeq elements;
};

struct ElementData
{
    long id;
    string facet;
    ByteSeq sampleFilter;
}
sequence<ElementData> ElementDataSeq;

struct ElementSpec
{
    ElementDataSeq elements;
    long valueId;
    ByteSeq value;
    long peerValueId;
}
sequence<ElementSpec> ElementSpecSeq;

struct ElementDataAck
{
    long id;
    string facet;
    ByteSeq sampleFilter;
    DataSampleSeq samples;
    long peerId;
}
sequence<ElementDataAck> ElementDataAckSeq;

struct ElementSpecAck
{
    ElementDataAckSeq elements;
    long valueId;
    ByteSeq value;
    long peerValueId;
}
sequence<ElementSpecAck> ElementSpecAckSeq;

interface Session
{
    void announceTopics(TopicInfoSeq topics);
    void attachTopic(TopicSpec topic);
    void detachTopic(long topic);

    void announceElements(long topic, ElementInfoSeq keys);
    void attachElements(long topic, long lastId, ElementSpecSeq elements);
    void attachElementsAck(long topic, long lastId, ElementSpecAckSeq elements);
    void detachElements(long topic, LongSeq keys);

    void initSamples(long topic, DataSamplesSeq samples);

    void destroy();
}

interface PublisherSession extends Session
{
}

interface SubscriberSession extends Session
{
    void s(long topic, long element, DataSample sample);
}

interface Node
{
    ["amd"] SubscriberSession* createSubscriberSession(Node* publisher, PublisherSession* session);
    ["amd"] PublisherSession* createPublisherSession(Node* subscriber, SubscriberSession* session);
}

interface TopicLookup
{
    idempotent void announceTopicReader(string topic, Node* node);
    idempotent void announceTopicWriter(string topic, Node* node);
}

}

