---
description: >-
  Blinded paths allow the creator of an invoice to specify the last hops that a
  payment to their node must take. This path is included in the Lightning
  Network invoice in encrypted form.
---

# Blinded Paths

Starting from LND 0.18.3 users have the option to define the last hops of any Lightning Network payment.

Invoices created with the `--blind` option use a new dummy destination pubkey, and typically contain three alternative paths, each with three hops. Only the first hop of that path is revealed. It is referred to as the “introduction node.” This path is included in the invoice in encrypted form. The payer will only have to construct their route to the introduction node and append the binary blobs from the invoice.

Invoices with blinded paths can be quite long. This may make them impractical for traditional QR codes. The size can be reduced by limiting the number of blinded paths per invoice.

When only a limited number of short paths exist between two nodes, blinded paths may not be payable and the recipient may still be identifiable through other analysis, such as correlating the fees of real channels around the introduction node with those of the blinded path.

## Blinded path example

In the example below we generate an invoice with the command `lncli addinvoice 100 --blind`

`lnbc1u1pn0mykwpp5nqz5z6md5z6hss8thmpd2d57cqep7xxqraq9fzcytx7hvv5sg9wqdqqxqyz5vq5jhqqqqphgqqqpf2qf0qqqqqqqqqqzycqqqqqq63h9xqqqqqq4c0utvs26cyazs3jey8twnq9ada2grez3ad0wlmamyq2hwmx4m05psyg7h4fy3uf4rq76zqwgkhrtqmmvvl6pjsp45xttvlsnca93hf7d2ge58a5e40u03776q54z7menaez9ae54exq60ssnnvf8vympsh3cdqxf7elncw9v43944llnfac4vvm3sss8wgen4dkfcp30yfc5sj496ku8pva7d65p0h0hxudhde4sgcrj4ewd4fc23mr5m3lu7esgyke9mgp9ewwlx2kzx8qlqzgyynrmcdxasxe5yukv864dlusf2tpqcksjfnxgsuutxd9r8hxf5mw868vzu870yk9fkxj6ausedug9y6jpf6zkz4qp3vtwa2vu4enay9dguq09z7lv2s6ettz34tlefyrj6us2cffvqg80g7kyzk0r0w24d8sw823k6s3eqydlrgy5ehqy0mq7n56mjlk4z6vvzclu35tzlrmuhywqqjqvm5a4km3t2wxfeesh0kv6qcaq94dwgd5l3ngmkp2qhdu2h6f60pg75d6w9ltc5jgqqqqfwcqqqqa5q2lqqqqqqqqqqzycqqqqqqz46j5qqqqqqafqerczge4wuehqtup2mldh80yy28q2w84a30yq2m4g2rfkdnvgvps8s2hj3kvrnfhdwffudsqdej9ltjfpvd36s2kksxmsp8qrd9a5jxdgvh88j9hhc04z9ac8knp4u57qvl6sn4wvuqudld6eutfxgf92ham2as9dze6d6n83stmdpege8n5lud7gv5708qh4hjuv90f3vfdgfu53slngqnnllv8t37y2aq7r6syk7r6wh3aestn9f6ht6ywjsdv2fn36qqddaps334233a6yems4539lfum5muxdsgzy642gjfwcvzrw54ge3zsukuesxx0w2pqsn0lqs6nwqdy3es7z5xcpqs8q5xep555dd7psczpsday7mqrmjyyhlgzksnd9twm9h9ymru4tna3aw72zy33e4y4zqdlpg26n48y85h2xwn75yxpvjvalg5ttwtux9uz4jl576dc0keh9qvkduwp0yfammhddvdmch6vrq3mzpgppzr9hw240w506xg6dsjdw5d0psuy4r9ggawq5jgqqqqfwgqqqpk7q2lqqqqqqqqqqzycqqqqqq63h9xqqqqqqmkf0zees7hx5mmtqcand60ek9qw5c26wj7ludrntwwj2tadc87aypsx00wn34q4lzqllv0yltgaunq70j7rsv7t8r0nwmq07cyc82f02qfgwem8rhqgrncpc5qxn6rw5kk2pn8kzu5r93cxs9yneztc04pygr2mfvezv93gxa3wz3s52trrsahjkdac8rrtujutt9hm37d2k55695dyv4u5qcmqy3cqgqj4vt8jtjz4l7cee0njfdcqm64adaetp8x4yl3qu5h4apmp25p3xq3z3nmx7wc4jc5er496tzaer6v8frds38h842uku62qeu80j2uf4duptgu65fafpdp2f5vfn85fj5l7ejhvfde2qhgagrrtcx7yggr4m3hnrpz2hewfqqw38qns03m7g9h08gg2c8pp8k9q6kz8ruu39qyx2vx6n7lq9s95aqpq4f28xf5w4ajk44enwznqwr6rum8daznju5dpvfne6xes9qamgv3v9l060g2mt7jhe42em04zvq00mccgrqqv2h8kg0n9p4yqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpq9qgqqf98d722zvu5jg55qw8g7p6h07svytvg88rrkt2nj430fhuddc58xcmfrjal4h7jddwcn9m78k60d3tw8fywqwga7weh58ay2tc8recqqwpcuj`

Decoding this invoice reveals the three alternative paths, their introduction nodes and respective fees.

```
{
	"destination":  "021b551120ff8a4503a8732b6e44c4baf23abf6d6c2911caa8bfb114b180da41e6",
	"payment_hash":  "9805416b6da0b57840ebbec2d5369ec0321f18c01f40548b0459bd763290415c",
	"num_satoshis":  "100",
	"timestamp":  "1727894222",
	"expiry":  "86400",
	"description":  "",
	"description_hash":  "",
	"fallback_addr":  "",
	"cltv_expiry":  "18",
	"route_hints":  [],
	"payment_addr":  "",
	"num_msat":  "100000",
	"features":  {
    	"8":  {
        	"name":  "tlv-onion",
        	"is_required":  true,
        	"is_known":  true
    	},
    	"15":  {
        	"name":  "payment-addr",
        	"is_required":  false,
        	"is_known":  true
    	},
    	"17":  {
        	"name":  "multi-path-payments",
        	"is_required":  false,
        	"is_known":  true
    	},
    	"25":  {
        	"name":  "route-blinding",
        	"is_required":  false,
        	"is_known":  true
    	},
    	"262":  {
        	"name":  "bolt-11-blinded-paths",
        	"is_required":  true,
        	"is_known":  true
    	}
	},
	"blinded_paths":  [
    	{
        	"blinded_path":  {
            	"introduction_node":  "0223d7aa491e26a307b4203916b8d60ded8cfe832806b432d6cfc278e96374f9aa",
            	"blinding_point":  "02b87f16c82b58274508cb243add3017adea903c8a3d6bddfdf76402aeed9abb7d",
            	"blinded_hops":  [
                	{
                    	"blinded_node":  "0223d7aa491e26a307b4203916b8d60ded8cfe832806b432d6cfc278e96374f9aa",
                    	"encrypted_data":  "687ed3357f1f1f7b40a545ede67dc88bdcd2b93034f84273624ec26c30bc70d0193ecfe7871595896b5ffe69ee2ac66e30840ee466756d9380c5e44e290954bab70e1677cdd5"
                	},
                	{
                    	"blinded_node":  "02fbbee6e36edcd608c0e55cb9b54e151d8e9b8ff9ecc104b64bb404b973be6558",
                    	"encrypted_data":  "383e01208498f7869bb036684e5987d55bfe412a58418b424999910e716669467b9934db8fa3b05c3f9e4b153634b5de432de20a4d4829d0ac2a803162ddd53395ccfa42b51c"
                	},
                	{
                    	"blinded_node":  "03ca2f7d8a86b2b58a355ff2920e5ae41584a58041de8f5882b3c6f72aad3c1c75",
                    	"encrypted_data":  "da84720237e341299b808fd83d3a6b72fdaa2d3182c7f91a2c5f1ef97238009019ba76b6dc56a71939cc2efb3340c7405ab5c86d3f19a3760a8176f157d274f0a3d46e9c5faf"
                	}
            	]
        	},
        	"base_fee_msat":  "221",
        	"proportional_fee_rate":  661,
        	"total_cltv_delta":  303,
        	"htlc_min_msat":  "1100",
        	"htlc_max_msat":  "7128000000",
        	"features":  []
    	},
    	{
        	"blinded_path":  {
            	"introduction_node":  "03c157946cc1cd376b929e36006e645fae490b1b1d4156b40db804e01b4bda48cd",
            	"blinding_point":  "03a906478123357733702f8156fedb9de4228e0538f5ec5e402b7542869b366c43",
            	"blinded_hops":  [
                	{
                    	"blinded_node":  "03c157946cc1cd376b929e36006e645fae490b1b1d4156b40db804e01b4bda48cd",
                    	"encrypted_data":  "2e73c8b7be1f5117b83da61af29e033fa84eae6701c6fdbacf1693212555fbb5760568b3a6ea678c17b68728c9e74ff1be4329e79c17ade5c615e98b12d427948c3f34"
                	},
                	{
                    	"blinded_node":  "0273ffd875c7c45741e1ea04b787a75e3dcc1732a7575e88e941ac52671d000d6f",
                    	"encrypted_data":  "08c6aa8c7ba26770ad225fa79ba6f866c10226aaa4492ec3043752a8cc450e5b99818cf7282084dff04353701a48e61e150d808207050d90d2946b7c186041837a4f6c"
                	},
                	{
                    	"blinded_node":  "03dc884bfd02b426d2addb2dca4d8f955cfb1ebbca11231cd495101bf0a15a9d4e",
                    	"encrypted_data":  "d2ea33a7ea10c16499dfa28b5b97c31782acbf4f69b87db37281966f1c17913ddeeed6b1bbc5f4c1823b1050108865bb9557ba8fd191a6c24d751af0c384a8ca8475c0"
                	}
            	]
        	},
        	"base_fee_msat":  "1211",
        	"proportional_fee_rate":  474,
        	"total_cltv_delta":  351,
        	"htlc_min_msat":  "1100",
        	"htlc_max_msat":  "720000000",
        	"features":  []
    	},
    	{
        	"blinded_path":  {
            	"introduction_node":  "033dee9c6a0afc40ffd8f27d68ef260f3e5e1c19e59c6f9bb607fb04c1d497a809",
            	"blinding_point":  "03764bc59cc3d73537b5831d9b74fcd8a07530ad3a5eff1a39adce9297d6e0fee9",
            	"blinded_hops":  [
                	{
                    	"blinded_node":  "033dee9c6a0afc40ffd8f27d68ef260f3e5e1c19e59c6f9bb607fb04c1d497a809",
                    	"encrypted_data":  "b3b38ee040e780e28034f43752d650667b0b9419638340a49e44bc3ea12206ada599130b141bb170a30a29631c3b7959bdc1c635f25c5acb7dc7cd55a94d168d232bca"
                	},
                	{
                    	"blinded_node":  "031b0123802012ab16792e42affd8ce5f3925b806f55eb7b9584e6a93f107297af",
                    	"encrypted_data":  "b0aa81898111467b379d8acb14c8ea5d2c5dc8f4c3a46d844f73d55cb734a067877c95c4d5bc0ad1cd513d485a15268c4ccf44ca9ff6657625b9502e8ea0635e0de221"
                	},
                	{
                    	"blinded_node":  "03aee3798c2255f2e4800e89c1383e3bf20b779d08560e109ec506ac238f9c8940",
                    	"encrypted_data":  "2986d4fdf01605a74010552a39934757b2b56b99b8530387a1f3676f4539728d0b133ce8d98141dda191617efd3d0adafd2be6aacedf51300f7ef1840c0062ae7b21f3"
                	}
            	]
        	},
        	"base_fee_msat":  "1209",
        	"proportional_fee_rate":  879,
        	"total_cltv_delta":  351,
        	"htlc_min_msat":  "1100",
        	"htlc_max_msat":  "7128000000",
        	"features":  []
    	}
	]
}
```

Additionally, it is possible to specify the number of real hops used in the blinded paths (`--min_real_blinded_hops`), the number of hops to be used for each blinded path (`--num_blinded_hops`) and the maximum number of blinded paths (`--max_blinded_paths`).

It is also possible to specifically exclude nodes from blinded paths with the `--blinded_path_omit_node` flag.
