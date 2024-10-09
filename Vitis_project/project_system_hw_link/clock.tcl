set mrmac_userclk [get_clocks clkout1_primitive]
set mrmac_userclk_period [get_property PERIOD [get_clocks clkout1_primitive]]
set_max_delay -datapath_only -from $mrmac_userclk -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */mbufg_gt_*/U0/USE_MBUFG_GT*.GEN_MBUFG_GT*.MBUFG_GT_U/O*}]] $mrmac_userclk_period
set_max_delay -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */mbufg_gt_*/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] -to $mrmac_userclk $mrmac_userclk_period
