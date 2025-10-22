---
description: Structure your stablecoin asset and associate metadata
---

# Asset Metadata

The Taproot Assets protocol itself places very few restrictions on what data can be associated with a new asset, and how that data should be structured.

When minting a new asset, we have to consider a few parameters. We can also include additional information as part of the metadata, which can be defined at the time of minting in the form of a json string or file.

**Type**\
An asset can be either set to normal or collectible. A normal asset is divisible into parts of equal value.

**Name**\
An asset requires a name. Uniqueness cannot be enforced over this name, so it can’t be used to uniquely identify the asset.

**Supply**\
The total supply of your asset. This will include the decimal places. An asset with 1,000 units and three decimal places has a total supply of 1,000,000.

**Decimal display**\
The number of decimal places your asset will have. Two decimal places would allow only for cents, while six decimal places would allow for micro-units. Too few decimal places can result in rounding errors when transferring assets over the Lightning Network. You can choose up to 12 decimal places.

[Learn more: Decimal display](decimal-display.md)

**Grouped Asset**\
For grouped assets the total supply can later be inflated, while ungrouped assets have a permanently fixed supply.

**Meta Data**\
You can associate your asset with additional metadata. This data can be added in the form of a string (--meta\_bytes), a file on disk (--meta\_file\_path), and be either in opaque or json form (--meta\_type).

While there are no formal restrictions on the metadata beyond a 1MB size limit, we do recommend an emerging standard for stablecoin assets that is expected to maximize interoperability between assets and wallets.

```json
{
  "spec": "stablecoin",
  "version": 1,
  "ticker": "BBX",
  "long_name": "Beefbucks",
  "description": "All BFBX tokens are pegged at 1-to-1 with a matching fiat currency and are backed 100% by Beefbuck's Reserves. Information about Beefbucks in circulation is typically published daily.",
  "logo_image": "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDgiIGhlaWdodD0iNDgiIHZpZXdCb3g9IjAgMCA0OCA0OCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGcgaWQ9IkZyYW1lIDUyNjAiPgo8cmVjdCB3aWR0aD0iNDgiIGhlaWdodD0iNDgiIHJ4PSIyNCIgZmlsbD0iIzI2QTE3QiIvPgo8cGF0aCBpZD0iVmVjdG9yIiBkPSJNMjYuNTcwOSAyNS44MThDMjYuNDI4NiAyNS44MTggMjUuODE2NiAyNS44NzYzIDI0LjAyNzcgMjUuODc2M0MyMi41OTM3IDI1Ljg3NjMgMjEuNzgyOSAyNS44MzM0IDIxLjQyOCAyNS44MThDMTUuOTA1NCAyNS41NzI5IDExLjU3NjkgMjQuNjA0MyAxMS41NzY5IDIzLjQzMzRDMTEuNTc2OSAyMi4yNjI2IDE1LjkwNTQgMjEuMjc5NCAyMS40MjggMjEuMDMzNFYyNC44NTAzSDI2LjU3MDlWMjEuMDM0M0MzMi4wNzg5IDIxLjI3OTQgMzYuNDA3NCAyMi4yNjI2IDM2LjQwNzQgMjMuNDMzNEMzNi40MDc0IDI0LjU4OTcgMzIuMDc4OSAyNS41NzI5IDI2LjU3MDkgMjUuODE4Wk0yNi41NzA5IDIwLjYyOTdWMTcuMTQyOUgzNC4yODUyVjEySDEzLjcxMzdWMTcuMTQyOUgyMS40MjhWMjAuNjI4OUMxNS4xODEyIDIwLjkxODYgMTAuMjg1MiAyMi4xOTA2IDEwLjI4NTIgMjMuNjkzMUwxMC4yODUyIDI1LjE5NjYgMTUuMTgxMiAyNi40Njg2IDIxLjQyOCAyNi43NTgzVjM3LjcxNDNIMjYuNTcwOVYyNi43NTgzQzMyLjgxNzcgMjYuNDY4NiAzNy43MTM3IDI1LjE5NjYgMzcuNzEzNyAyMy42OTMxQzM3LjcxMzcgMjIuMTkwNiAzMi44MTc3IDIwLjkzMzEgMjYuNTcwOSAyMC42Mjg5VjIwLjYyOTdaIiBmaWxsPSJ3aGl0ZSIvPgo8L2c+Cjwvc3ZnPgo="
}

```

The image is a square of at most 128 pixels, encoded in Base64.

The metadata of a grouped asset can be updated each time a new tranche is issued. Wallets and explorers should display the metadata associated with the most recent mint.

The decimal display should be defined through the CLI flag or API parameter. The `tapd` daemon will append it to the json metadata, from where wallets can interpret it.

The metadata for a given asset ID can be retrieved with:

`tapcli assets --asset_id <id> | jq -r '.data' | xxd -p -r | jq`
