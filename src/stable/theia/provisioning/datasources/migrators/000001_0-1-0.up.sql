--Create a table to store records
CREATE TABLE IF NOT EXISTS flows_local (
    timeInserted DateTime DEFAULT now(),
    flowStartSeconds DateTime,
    flowEndSeconds DateTime,
    flowEndSecondsFromSourceNode DateTime,
    flowEndSecondsFromDestinationNode DateTime,
    flowEndReason UInt8,
    sourceIP String,
    destinationIP String,
    sourceTransportPort UInt16,
    destinationTransportPort UInt16,
    protocolIdentifier UInt8,
    packetTotalCount UInt64,
    octetTotalCount UInt64,
    packetDeltaCount UInt64,
    octetDeltaCount UInt64,
    reversePacketTotalCount UInt64,
    reverseOctetTotalCount UInt64,
    reversePacketDeltaCount UInt64,
    reverseOctetDeltaCount UInt64,
    sourcePodName String,
    sourcePodNamespace String,
    sourceNodeName String,
    destinationPodName String,
    destinationPodNamespace String,
    destinationNodeName String,
    destinationClusterIP String,
    destinationServicePort UInt16,
    destinationServicePortName String,
    ingressNetworkPolicyName String,
    ingressNetworkPolicyNamespace String,
    ingressNetworkPolicyRuleName String,
    ingressNetworkPolicyRuleAction UInt8,
    ingressNetworkPolicyType UInt8,
    egressNetworkPolicyName String,
    egressNetworkPolicyNamespace String,
    egressNetworkPolicyRuleName String,
    egressNetworkPolicyRuleAction UInt8,
    egressNetworkPolicyType UInt8,
    tcpState String,
    flowType UInt8,
    sourcePodLabels String,
    destinationPodLabels String,
    throughput UInt64,
    reverseThroughput UInt64,
    throughputFromSourceNode UInt64,
    throughputFromDestinationNode UInt64,
    reverseThroughputFromSourceNode UInt64,
    reverseThroughputFromDestinationNode UInt64,
    trusted UInt8 DEFAULT 0
) engine=ReplicatedMergeTree('/clickhouse/tables/{shard}/{database}/{table}', '{replica}')
ORDER BY (timeInserted, flowEndSeconds);

--Move data from old table and drop old tables
INSERT INTO flows_local SELECT * FROM flows;
DROP TABLE flows;
DROP VIEW flows_pod_view;
DROP VIEW flows_node_view;
DROP VIEW flows_policy_view;

--Create a table to store the network policy recommendation results
CREATE TABLE IF NOT EXISTS recommendations_local (
    id String,
    type String,
    timeCreated DateTime,
    yamls String
) engine=ReplicatedMergeTree('/clickhouse/tables/{shard}/{database}/{table}', '{replica}')
ORDER BY (timeCreated);

--Move data from old table and drop the old table
INSERT INTO recommendations_local SELECT * FROM recommendations;
DROP TABLE recommendations;

CREATE TABLE IF NOT EXISTS flows AS flows_local
engine=Distributed('{cluster}', default, flows_local, rand());

CREATE TABLE IF NOT EXISTS recommendations AS recommendations_local
engine=Distributed('{cluster}', default, recommendations_local, rand());
