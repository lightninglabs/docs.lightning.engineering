---
description: >-
  Learn how to mint your own collectibles, as well as collections of
  collectibles.
---

# Collectibles

In addition to fungible, "normal" assets, Taproot Assets supports the creation and transfer of collectible, non-fungible assets.

A digital collectible can take on any form. The collectible itself may be referenced in the form of a hash or text, or may be directly embedded in the meta data itself. When minting a collectible, you have the option to pass any kind of data via `--meta_bytes`, such as text, images encoded data of any form or even a binary blob. Alternatively, any file can be passed to tapd with the `--meta_file_path` flag.

Meta data is limited to 1MB per asset.

Example:

`tapcli assets mint --type collectible --name theone --meta_bytes "One of a kind" --supply 1`

`tapcli assets mint finalize`

## Collections

Multiple collectibles can be grouped together into a collection. Each asset has its own asset ID, while the collection itself can be identified by its group key. To create such a collection, the `--new_group_emission` flag has to be set, and each subsequent collectible has to set the `--grouped_asset` flag as well as reference the first collectible by its name. Multiple collectibles can be minted in a batch.

`tapcli assets mint --type collectible --name member001 --meta_bytes 546170726f6f742041737365747320436c7562204d656d62657220303031 --supply 1 --new_group_emission`

`tapcli assets mint --type collectible --name member002 --meta_bytes 546170726f6f742041737365747320436c7562204d656d62657220303032 --grouped_asset --supply 1 --group_anchor member001`

`tapcli assets mint --type collectible --name member003 --meta_bytes 546170726f6f742041737365747320436c7562204d656d62657220303033 --grouped_asset --supply 1 --group_anchor member001`

`tapcli assets mint finalize`

At this point there is no option to "close" a batch or limit future emissions of that group.
