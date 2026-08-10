---
description: Unilaterally exit onchain at any time by publishing your VTXOs
---

# Unilateral Exit

Wavelength gives you the option to unilaterally exit and claim your VTXOs on the Bitcoin Blockchain. This is useful if the Wavelength operator is unresponsive for a longer period of time.

Unilateral exit can take an extended amount of time and be costly. The exact cost depends on the “chain depth”, the expiration of the VTXO and onchain fees.

To unilaterally exit, you will need your waved client, its data and some Bitcoin utxos from an external wallet.

## List VTXOs

To begin, list your VTXOs.

`wavecli ark vtxos list`

```
    {
      "outpoint": "3b9a6dd329aeabd1d21ca13e49cc2a9a3ac2243a2e1d5007c033573df1e3b8ff:0",
      "amount_sat": "13745",
      "status": "VTXO_STATUS_LIVE",
      "batch_expiry": 317414,
      "round_id": "019fd473-aa75-7057-a80f-2f139726218f",
      "created_height": 316406,
      "relative_expiry": 144,
      "pk_script": "51200dbe3c46e75dd4cdd4ae9bc98e8ad9c3859530f8b95ead6df19e3bb41374ed94",
      "commitment_txid": "2e7f2c5562e13a0abc50d10b5209952ac8b2a765b38b728694b8823b76dab02f",
      "chain_depth": 2,
      "oor_final_checkpoint_psbts": [
        "cHNidP8BAGsDAAAAAXGHvdiiA3eHHs6SRgz5TSwtNeOfKw1XV5tXCM6sFLwbAQAAAAD/////AklwAAAAAAAAIlEgndzIQ2pnh//dJLrvfXIi39Tg+GTgxHVbOuHCtnhwMUEAAAAAAAAAAARRAk5zAAAAAAABAStJcAAAAAAAACJRIEt05Dw5iGCZsGiR3+PCA17d9tMn2SAVTur/mJbLbnhkQRR9Niz1P1/jq3UpdOK4AIMCNZz3rkKl8xbHL5BEUI8wuWI3aUu4YtQqDGi7jw7JAW9mr3kSeuDgkz+skqf1pU/fQJAJQVXRSmbQ6J6bdONMWSmBEjV8oM+iLEbZKGRkavJD3dFFSM0ywnYF53lGiddcSWbhIDK0cfMqpaPh0ZLzxr9BFLyd4NXNYDYthTk+GkUOLjp1ifW0/pxE33LrLekgJkl4YjdpS7hi1CoMaLuPDskBb2aveRJ64OCTP6ySp/WlT99Ahk71T6472Jxtgih0IuRLJGFsHYELrHsiEHgPwzQv3ERU5MUAG17yOWYHEKaANJGxJkENJwUGN+UlXDykLXXAjkIVwTcvIls8rughMJbeMinuQzUwawfDwWlDhGG11HSYhOxlJYTZxHYeGXes/e5V6WLAxtzsMIPyoWEyabFGpx8WYPFFILyd4NXNYDYthTk+GkUOLjp1ifW0/pxE33LrLekgJkl4rSB9Niz1P1/jq3UpdOK4AIMCNZz3rkKl8xbHL5BEUI8wuazAAAEGfAEBAAN3LAEBwAInIH02LPU/X+OrdSl04rgAgwI1nPeuQqXzFscvkERQjzC5rAKQALJ1SQEBwAJEILyd4NXNYDYthTk+GkUOLjp1ifW0/pxE33LrLekgJkl4rSB9Niz1P1/jq3UpdOK4AIMCNZz3rkKl8xbHL5BEUI8wuawAAA=="
      ],
      "spent_by_txid": "",
      "expiry_info": null,
      "settlement": null
    }
```

## Plan the exit <a href="#docs-internal-guid-966fc15e-7fff-4ed4-d673-b122e4e62050" id="docs-internal-guid-966fc15e-7fff-4ed4-d673-b122e4e62050"></a>

To plan the exit, we will need the outpoint of the VTXO we would like to claim onchain.

`wavecli exit plan --outpoint 3b9a6dd329aeabd1d21ca13e49cc2a9a3ac2243a2e1d5007c033573df1e3b8ff:0`

```
{
  "plans": [
    {
      "outpoint": "3b9a6dd329aeabd1d21ca13e49cc2a9a3ac2243a2e1d5007c033573df1e3b8ff:0",
      "funding_address": "tb1pjrjclndvmr4sfw53umdew44v6m40mgxwww5vd0x2mvus02gtm42q07yxpm",
      "required_confirmations": 1,
      "required_fee_utxo_count": 1,
      "usable_fee_utxo_count": 0,
      "recommended_utxo_amount_sat": "10000",
      "recommended_total_funding_sat": "10000",
      "funding_shortfall_sat": "10000",
      "can_start": false,
      "exit_job_found": false,
      "exit_status": "EXIT_JOB_STATUS_UNSPECIFIED",
      "sweep_txid": "",
      "last_error": "",
      "error": "",
      "infeasibility_reason": "EXIT_INFEASIBILITY_REASON_WALLET_UNDERFUNDED"
    }
  ],
  "fee_rate_sat_per_vbyte": "2",
  "can_start": false,
  "total_funding_shortfall_sat": "10000",
  "total_recommended_funding_sat": "10000"
}
```

From the output above we learn how many UTXOs we require (1) and their amount (10,000 sat). We also learn where to deposit these funds (`tb1pjrjclndvmr4sfw53umdew44v6m40mgxwww5vd0x2mvus02gtm42q07yxpm`).

Once the address shown above has at least one UTXO with the required amount, you should see `"can_start": true` and `"funding_shortfall_sat": "0"`

This signals that you may go ahead with the exit.

## Exit <a href="#docs-internal-guid-933fdfab-7fff-18bd-bd5a-dbdaa0b6843a" id="docs-internal-guid-933fdfab-7fff-18bd-bd5a-dbdaa0b6843a"></a>

To exit Wavelength, you may run a command like:

`wavecli exit --outpoint 3b9a6dd329aeabd1d21ca13e49cc2a9a3ac2243a2e1d5007c033573df1e3b8ff:0 --force-unroll-ack --dry-run`

The `--dry-run` flag allows you to check whether all checks pass, without publishing the transactions.

Run the command again without this flag to begin your unilateral exit.

```
{
  "created": true,
  "actor_id": "unroll-3b9a6dd329aeabd1d21ca13e49cc2a9a3ac2243a2e1d5007c033573df1e3b8ff:0",
  "mode": "EXIT_MODE_UNILATERAL",
  "queued_outpoints": [],
  "onchain_address": ""
}
```

## Monitoring <a href="#docs-internal-guid-a6ee115b-7fff-9a77-8f1c-1730bc641c77" id="docs-internal-guid-a6ee115b-7fff-9a77-8f1c-1730bc641c77"></a>

You can check your progress with the command:

`wavecli exit status --outpoint 3b9a6dd329aeabd1d21ca13e49cc2a9a3ac2243a2e1d5007c033573df1e3b8ff:0`

Most importantly, look at the phase\_detail. It will tell you how many transactions are required, and how many are still pending. Each new transaction will take a minimum of one block.

```
{
  "found": true,
  "status": "EXIT_JOB_STATUS_MATERIALIZING",
  "sweep_txid": "",
  "last_error": "",
  "phase_detail": "materializing recovery tree: layer 3 of 5, 2/5 txs confirmed (1 in flight, 0 ready, 2 blocked)",
  "progress": {
    "confirmed_txs": 2,
    "in_flight_txs": 1,
    "ready_txs": 0,
    "blocked_txs": 2,
    "total_txs": 5,
    "current_layer": 2,
    "total_layers": 5,
    "target_confirmed": false,
    "all_proof_confirmed": false
  },
  "csv": null,
  "fees": {
    "cpfp_fee_sat": "3362",
    "sweep_fee_sat": "400",
    "total_cost_sat": "3762",
    "vtxo_amount_sat": "13745",
    "net_recovered_sat": "13345",
    "fee_rate_sat_vbyte": "2",
    "sweep_fee_actual": false,
    "spent_so_far_sat": "2017"
  },
  "best_case_blocks_remaining": 148,
  "current_height": 316567
}
```

Once all transactions are confirmed, you will have to wait for the UTXO to mature before it can be swept into your wallet.

`"phase_detail": "all recovery txs confirmed; waiting for CSV maturity (144 blocks remaining, matures at height 316719)"`

After the UTXOs have been swept you will see the `phase_detail` has changed to exit complete.

```
{
  "found": true,
  "status": "EXIT_JOB_STATUS_COMPLETED",
  "sweep_txid": "272d9a1721925ec7ec825301b133ebda4c9de80726361e99c95467f7c9e277d2",
  "last_error": "",
  "phase_detail": "exit complete; funds swept to the backing wallet",
  "progress": null,
  "csv": null,
  "fees": {
    "cpfp_fee_sat": "1978",
    "sweep_fee_sat": "400",
    "total_cost_sat": "2378",
    "vtxo_amount_sat": "13745",
    "net_recovered_sat": "13345",
    "fee_rate_sat_vbyte": "2",
    "sweep_fee_actual": false,
    "spent_so_far_sat": "2378"
  },
  "best_case_blocks_remaining": 0,
  "current_height": 0
}
```

You can now prepare to sweep your funds to a wallet of your choice with:

`wavecli --datadir=~/.waved-btcwallet wallet-sweep --destination tb1qsvdwlk9me50lez492qv09l2ql3s00hczm5xyl4 --fee-rate 1`

To broadcast the transaction and finalize the sweep, append `--broadcast` to the command.

Curious to learn more? Follow the unilateral exit above on the Bitcoin Signet Blockchain!

