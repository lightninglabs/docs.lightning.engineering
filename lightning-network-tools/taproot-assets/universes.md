---
description: Learn how to run a universe
---

# Universes

## Running a universe <a href="#docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f" id="docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f"></a>

Running a universe is as simple as running `tapd` and amending your configuration file. To run a universe, set your instance to listen on the RPC port (10029) and ensure this port is open on your machine. Being publicly reachable is not a requirement for a universe, however. Your universe may only serve resources on a private network, or be otherwise restricted.

Sample`tapd.conf` file:

`rpclisten=0.0.0.0:10029`\
`allow-public-uni-proof-courier=true`\
`allow-public-stats=true universe.public-access=true`

