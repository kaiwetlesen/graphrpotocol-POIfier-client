#!/bin/sh

# POIFIER RUNTIME WRAPPER
#
# Makes life less annoying by wrapping CLI arguments inside
# of a set of evironment variables.

# Variable correspondence:
# GRAPH_NODE_STATUS_ENDPOINT : --graph-node-status-endpoint
# POIFIER_TOKEN              : --poifier-token
# POIFIER_SERVER             : --poifier-server
# ETHEREUM_ENDPOINT          : --ethereum-endpoint

# Alternating variable correspondences:
# MAINNET_SUBGRAPH_ENDPOINT    : --mainnet-subgraph-endpoint
#       [OR]
# GRAPH_ENDPOINT + SUBGRAPH_ID : --mainnet-subgraph-endpoint="$GRAPH_ENDPOINT/$SUBGRAPH_ID"

[ -z "$POIFIER_TOKEN" ] && echo No POIFIER_TOKEN set, cannot run poifier && exit 1 ||\
	ARGS="--poifier-token $POIFIER_TOKEN"

if [ -n "$GRAPH_ENDPOINT" ] && [ -n "$SUBGRAPH_ID" ]; then
	ARGS="$ARGS --mainnet-subgraph-endpoint $GRAPH_ENDPOINT/$SUBGRAPH_ID"
elif [ -z "$GRAPH_ENDPOINT" ] && [ -n "$SUBGRAPH_ID" ]; then
	ARGS="$ARGS --mainnet-subgraph-endpoint http://query-node-0:8000/subgraphs/id/$SUBGRAPH_ID"
elif [ -n "$MAINNET_SUBGRAPH_ENDPOINT" ]; then
	ARGS="$ARGS --mainnet-subgraph-endpoint $MAINNET_SUBGRAPH_ENDPOINT"
# else let the default in poifier-client prevail
fi

[ -n "$POIFIER_SERVER" ] && ARGS="$ARGS --poifier-server $POIFIER_SERVER"
[ -n "$ETHEREUM_ENDPOINT" ] && ARGS="$ARGS --ethereum-endpoint $ETHEREUM_ENDPOINT"
[ -n "$GRAPH_NODE_STATUS_ENDPOINT" ] && ARGS="$ARGS --graph-node-status-endpoint $GRAPH_NODE_STATUS_ENDPOINT"

/usr/bin/env python3 /opt/poifier/poifier-client.py $ARGS
