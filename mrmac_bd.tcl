
################################################################
# This is a generated script based on design: mrmac_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source mrmac_bd_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project mrmac_bd mrmac_bd -part xcvc1902-vsvd1760-2MP-e-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name mrmac_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:mrmac:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CLK_IN_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {161132812} \
   ] $CLK_IN_D

  set GT_Serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial ]

  set s_axi_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {300000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $s_axi_0

  set mrmac_rx [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 mrmac_rx ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {390624848} \
   ] $mrmac_rx

  set mrmac_tx [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 mrmac_tx ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {390624848} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {48} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $mrmac_tx


  # Create ports
  set s_axi_aclk [ create_bd_port -dir I -type clk -freq_hz 300000000 s_axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi_0} \
   CONFIG.ASSOCIATED_RESET {s_axi_aresetn} \
 ] $s_axi_aclk
  set s_axi_aresetn [ create_bd_port -dir I -type rst s_axi_aresetn ]
  set clk_390 [ create_bd_port -dir I -type clk -freq_hz 390624848 clk_390 ]
  set resetn_390 [ create_bd_port -dir I -type rst resetn_390 ]

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.REG_CONFIG {0} \
    CONFIG.TDATA_NUM_BYTES {48} \
  ] $axis_register_slice_0


  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {0} \
    CONFIG.TDATA_NUM_BYTES {48} \
  ] $axis_register_slice_1


  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [list \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTY REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.PROT0_LR1_SETTINGS {PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ TX_HD_EN 0 RX_HD_EN 0 RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true\
TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 25.78125 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 161.1328125\
TX_ACTUAL_REFCLK_FREQUENCY 161.132812500000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE\
1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER\
false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 161.1328125 RX_ACTUAL_REFCLK_FREQUENCY 161.132812500000 RX_FRACN_ENABLED false\
RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE\
LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE\
800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE\
false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ\
0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false\
RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0\
false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000\
RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE\
RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0\
false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 } \
    CONFIG.PROT0_LR2_SETTINGS {PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ TX_HD_EN 0 RX_HD_EN 0 RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true\
TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 25.78125 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 161.1328125\
TX_ACTUAL_REFCLK_FREQUENCY 161.132812500000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE\
1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER\
false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 161.1328125 RX_ACTUAL_REFCLK_FREQUENCY 161.132812500000 RX_FRACN_ENABLED false\
RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE\
LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE\
800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE\
false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ\
0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false\
RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0\
false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000\
RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE\
RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0\
false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 } \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_161.1328125_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT0_R0_161.1328125_MHz_unique1} \
  ] $gt_quad_base


  # Create instance: mbufg_gt_0, and set properties
  set mbufg_gt_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_0 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_0


  # Create instance: mbufg_gt_1, and set properties
  set mbufg_gt_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1


  # Create instance: mbufg_gt_1_1, and set properties
  set mbufg_gt_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1_1 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_1


  # Create instance: mbufg_gt_1_2, and set properties
  set mbufg_gt_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1_2 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_2


  # Create instance: mbufg_gt_1_3, and set properties
  set mbufg_gt_1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1_3 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_3


  # Create instance: mrmac_0, and set properties
  set mrmac_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mrmac:2.1 mrmac_0 ]
  set_property -dict [list \
    CONFIG.GT_PIPELINE_STAGES {0} \
    CONFIG.GT_REF_CLK_FREQ_C0 {161.1328125} \
    CONFIG.MRMAC_CONFIGURATION_TYPE {Dynamic Configuration} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT0_C0 {Independent 384b Non-Segmented} \
    CONFIG.MRMAC_LOCATION_C0 {MRMAC_X0Y3} \
  ] $mrmac_0


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {4} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {4} \
  ] $util_vector_logic_1


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_0


  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_1


  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_2


  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_3


  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_4


  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {8} \
    CONFIG.IN1_WIDTH {3} \
  ] $xlconcat_5


  # Create instance: xlconcat_10, and set properties
  set xlconcat_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_10 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_10


  # Create instance: xlconst_mbufg_0, and set properties
  set xlconst_mbufg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconst_mbufg_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $xlconst_mbufg_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {3} \
  ] $xlconstant_0


  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {24019198012642773} \
    CONFIG.CONST_WIDTH {56} \
  ] $xlconstant_3


  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {63} \
    CONFIG.DIN_WIDTH {384} \
  ] $xlslice_0


  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {127} \
    CONFIG.DIN_TO {64} \
    CONFIG.DIN_WIDTH {384} \
  ] $xlslice_1


  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {191} \
    CONFIG.DIN_TO {128} \
    CONFIG.DIN_WIDTH {384} \
  ] $xlslice_2


  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {255} \
    CONFIG.DIN_TO {192} \
    CONFIG.DIN_WIDTH {384} \
  ] $xlslice_3


  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {15} \
    CONFIG.DIN_TO {8} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_5


  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DIN_TO {16} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_6


  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {24} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_7


  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {319} \
    CONFIG.DIN_TO {256} \
    CONFIG.DIN_WIDTH {384} \
    CONFIG.DOUT_WIDTH {64} \
  ] $xlslice_14


  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {383} \
    CONFIG.DIN_TO {320} \
    CONFIG.DIN_WIDTH {384} \
  ] $xlslice_15


  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {39} \
    CONFIG.DIN_TO {32} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_16


  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {47} \
    CONFIG.DIN_TO {40} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_17


  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {2} \
    CONFIG.CONST_WIDTH {8} \
  ] $xlconstant_4


  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {4} \
  ] $xlconstant_5


  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_4


  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property CONFIG.NUM_PORTS {6} $xlconcat_6


  # Create instance: xlconcat_7, and set properties
  set xlconcat_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_7 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {8} \
    CONFIG.IN1_WIDTH {8} \
    CONFIG.IN2_WIDTH {8} \
    CONFIG.IN3_WIDTH {8} \
    CONFIG.IN4_WIDTH {8} \
    CONFIG.IN5_WIDTH {8} \
    CONFIG.NUM_PORTS {6} \
  ] $xlconcat_7


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_ports CLK_IN_D] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net S_AXIS_0_1 [get_bd_intf_ports mrmac_tx] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_ports mrmac_rx] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net gt_quad_base_GT_Serial [get_bd_intf_ports GT_Serial] [get_bd_intf_pins gt_quad_base/GT_Serial]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_0 [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_0]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_1 [get_bd_intf_pins gt_quad_base/RX1_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_1]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_2 [get_bd_intf_pins gt_quad_base/RX2_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_2]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_3 [get_bd_intf_pins gt_quad_base/RX3_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_3]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_0 [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_0]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_1 [get_bd_intf_pins gt_quad_base/TX1_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_1]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_2 [get_bd_intf_pins gt_quad_base/TX2_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_2]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_3 [get_bd_intf_pins gt_quad_base/TX3_GT_IP_Interface] [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_3]
  connect_bd_intf_net -intf_net s_axi_0_1 [get_bd_intf_ports s_axi_0] [get_bd_intf_pins mrmac_0/s_axi]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins mrmac_0/rx_core_reset] [get_bd_pins mrmac_0/rx_serdes_reset]
  connect_bd_net -net aclk_0_1 [get_bd_ports clk_390] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins xlconcat_10/In0] [get_bd_pins xlconcat_10/In1] [get_bd_pins xlconcat_10/In2] [get_bd_pins xlconcat_10/In3] [get_bd_pins xlconcat_4/In0] [get_bd_pins xlconcat_4/In1] [get_bd_pins xlconcat_4/In2] [get_bd_pins xlconcat_4/In3]
  connect_bd_net -net aresetn_0_1 [get_bd_ports resetn_390] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_0/aresetn]
  connect_bd_net -net axis_data_fifo_4_m_axis_tdata [get_bd_pins axis_register_slice_0/m_axis_tdata] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net axis_data_fifo_4_m_axis_tkeep [get_bd_pins axis_register_slice_0/m_axis_tkeep] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net axis_register_slice_0_m_axis_tlast [get_bd_pins axis_register_slice_0/m_axis_tlast] [get_bd_pins mrmac_0/tx_axis_tlast_0]
  connect_bd_net -net axis_register_slice_0_m_axis_tvalid [get_bd_pins axis_register_slice_0/m_axis_tvalid] [get_bd_pins mrmac_0/tx_axis_tvalid_0]
  connect_bd_net -net gt_quad_base_ch0_rxoutclk [get_bd_pins gt_quad_base/ch0_rxoutclk] [get_bd_pins mbufg_gt_1/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch0_txoutclk [get_bd_pins gt_quad_base/ch0_txoutclk] [get_bd_pins mbufg_gt_0/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch1_rxoutclk [get_bd_pins gt_quad_base/ch1_rxoutclk] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch2_rxoutclk [get_bd_pins gt_quad_base/ch2_rxoutclk] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch3_rxoutclk [get_bd_pins gt_quad_base/ch3_rxoutclk] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_gtpowergood [get_bd_pins gt_quad_base/gtpowergood] [get_bd_pins mrmac_0/gtpowergood_in]
  connect_bd_net -net mbufg_gt_0_MBUFG_GT_O1 [get_bd_pins mbufg_gt_0/MBUFG_GT_O1] [get_bd_pins xlconcat_2/In0] [get_bd_pins xlconcat_2/In1] [get_bd_pins xlconcat_2/In2] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net mbufg_gt_0_MBUFG_GT_O2 [get_bd_pins mbufg_gt_0/MBUFG_GT_O2] [get_bd_pins gt_quad_base/ch0_txusrclk] [get_bd_pins gt_quad_base/ch1_txusrclk] [get_bd_pins gt_quad_base/ch2_txusrclk] [get_bd_pins gt_quad_base/ch3_txusrclk] [get_bd_pins xlconcat_3/In0] [get_bd_pins xlconcat_3/In1] [get_bd_pins xlconcat_3/In2] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net mbufg_gt_1_1_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1_1/MBUFG_GT_O1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net mbufg_gt_1_1_MBUFG_GT_O2 [get_bd_pins mbufg_gt_1_1/MBUFG_GT_O2] [get_bd_pins gt_quad_base/ch1_rxusrclk] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net mbufg_gt_1_2_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1_2/MBUFG_GT_O1] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net mbufg_gt_1_2_MBUFG_GT_O2 [get_bd_pins mbufg_gt_1_2/MBUFG_GT_O2] [get_bd_pins gt_quad_base/ch2_rxusrclk] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net mbufg_gt_1_3_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1_3/MBUFG_GT_O1] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net mbufg_gt_1_3_MBUFG_GT_O2 [get_bd_pins mbufg_gt_1_3/MBUFG_GT_O2] [get_bd_pins gt_quad_base/ch3_rxusrclk] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net mbufg_gt_1_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1/MBUFG_GT_O1] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net mbufg_gt_1_MBUFG_GT_O2 [get_bd_pins mbufg_gt_1/MBUFG_GT_O2] [get_bd_pins gt_quad_base/ch0_rxusrclk] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mrmac_0_gt_rx_reset_done_out [get_bd_pins mrmac_0/gt_rx_reset_done_out] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mrmac_0_gt_tx_reset_done_out1 [get_bd_pins mrmac_0/gt_tx_reset_done_out] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net mrmac_0_rx_axis_tdata0 [get_bd_pins mrmac_0/rx_axis_tdata0] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net mrmac_0_rx_axis_tdata1 [get_bd_pins mrmac_0/rx_axis_tdata1] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net mrmac_0_rx_axis_tdata2 [get_bd_pins mrmac_0/rx_axis_tdata2] [get_bd_pins xlconcat_6/In2]
  connect_bd_net -net mrmac_0_rx_axis_tdata3 [get_bd_pins mrmac_0/rx_axis_tdata3] [get_bd_pins xlconcat_6/In3]
  connect_bd_net -net mrmac_0_rx_axis_tdata4 [get_bd_pins mrmac_0/rx_axis_tdata4] [get_bd_pins xlconcat_6/In4]
  connect_bd_net -net mrmac_0_rx_axis_tdata5 [get_bd_pins mrmac_0/rx_axis_tdata5] [get_bd_pins xlconcat_6/In5]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0 [get_bd_pins mrmac_0/rx_axis_tkeep_user0] [get_bd_pins xlconcat_7/In0]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user1 [get_bd_pins mrmac_0/rx_axis_tkeep_user1] [get_bd_pins xlconcat_7/In1]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user2 [get_bd_pins mrmac_0/rx_axis_tkeep_user2] [get_bd_pins xlconcat_7/In2]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user3 [get_bd_pins mrmac_0/rx_axis_tkeep_user3] [get_bd_pins xlconcat_7/In3]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user4 [get_bd_pins mrmac_0/rx_axis_tkeep_user4] [get_bd_pins xlconcat_7/In4]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user5 [get_bd_pins mrmac_0/rx_axis_tkeep_user5] [get_bd_pins xlconcat_7/In5]
  connect_bd_net -net mrmac_0_rx_axis_tlast_0 [get_bd_pins mrmac_0/rx_axis_tlast_0] [get_bd_pins axis_register_slice_1/s_axis_tlast]
  connect_bd_net -net mrmac_0_rx_axis_tvalid_0 [get_bd_pins mrmac_0/rx_axis_tvalid_0] [get_bd_pins axis_register_slice_1/s_axis_tvalid]
  connect_bd_net -net mrmac_0_rx_clr_out_0 [get_bd_pins mrmac_0/rx_clr_out_0] [get_bd_pins mbufg_gt_1/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clr_out_1 [get_bd_pins mrmac_0/rx_clr_out_1] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clr_out_2 [get_bd_pins mrmac_0/rx_clr_out_2] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clr_out_3 [get_bd_pins mrmac_0/rx_clr_out_3] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_0 [get_bd_pins mrmac_0/rx_clrb_leaf_out_0] [get_bd_pins mbufg_gt_1/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_1 [get_bd_pins mrmac_0/rx_clrb_leaf_out_1] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_2 [get_bd_pins mrmac_0/rx_clrb_leaf_out_2] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_3 [get_bd_pins mrmac_0/rx_clrb_leaf_out_3] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_tx_axis_tready_0 [get_bd_pins mrmac_0/tx_axis_tready_0] [get_bd_pins axis_register_slice_0/m_axis_tready]
  connect_bd_net -net mrmac_0_tx_clr_out_0 [get_bd_pins mrmac_0/tx_clr_out_0] [get_bd_pins mbufg_gt_0/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_tx_clrb_leaf_out_0 [get_bd_pins mrmac_0/tx_clrb_leaf_out_0] [get_bd_pins mbufg_gt_0/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins gt_quad_base/apb3clk] [get_bd_pins mrmac_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_ports s_axi_aresetn] [get_bd_pins gt_quad_base/apb3presetn] [get_bd_pins mrmac_0/s_axi_aresetn]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins gt_quad_base/GT_REFCLK0]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins mrmac_0/tx_core_reset] [get_bd_pins mrmac_0/tx_serdes_reset]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins mrmac_0/rx_alt_serdes_clk] [get_bd_pins mrmac_0/rx_flexif_clk] [get_bd_pins mrmac_0/rx_ts_clk]
  connect_bd_net -net xlconcat_10_dout [get_bd_pins xlconcat_10/dout] [get_bd_pins mrmac_0/rx_axi_clk]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins mrmac_0/rx_core_clk] [get_bd_pins mrmac_0/rx_serdes_clk]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins xlconcat_3/dout] [get_bd_pins mrmac_0/tx_alt_serdes_clk] [get_bd_pins mrmac_0/tx_flexif_clk] [get_bd_pins mrmac_0/tx_ts_clk]
  connect_bd_net -net xlconcat_2_dout1 [get_bd_pins xlconcat_2/dout] [get_bd_pins mrmac_0/tx_core_clk]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins xlconcat_4/dout] [get_bd_pins mrmac_0/tx_axi_clk]
  connect_bd_net -net xlconcat_5_dout [get_bd_pins xlconcat_5/dout] [get_bd_pins mrmac_0/tx_axis_tkeep_user0]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins xlconcat_6/dout] [get_bd_pins axis_register_slice_1/s_axis_tdata]
  connect_bd_net -net xlconcat_7_dout [get_bd_pins xlconcat_7/dout] [get_bd_pins axis_register_slice_1/s_axis_tkeep]
  connect_bd_net -net xlconst_mbufg_0_dout [get_bd_pins xlconst_mbufg_0/dout] [get_bd_pins mbufg_gt_0/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CE]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconstant_3/dout] [get_bd_pins mrmac_0/tx_preamblein_0]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins xlconstant_4/dout] [get_bd_pins gt_quad_base/ch0_txrate] [get_bd_pins gt_quad_base/ch0_rxrate] [get_bd_pins gt_quad_base/ch1_rxrate] [get_bd_pins gt_quad_base/ch1_txrate] [get_bd_pins gt_quad_base/ch2_rxrate] [get_bd_pins gt_quad_base/ch2_txrate] [get_bd_pins gt_quad_base/ch3_rxrate] [get_bd_pins gt_quad_base/ch3_txrate]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins xlconstant_5/dout] [get_bd_pins mrmac_0/gt_reset_all_in]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlslice_0/Dout] [get_bd_pins mrmac_0/tx_axis_tdata0]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlslice_14/Dout] [get_bd_pins mrmac_0/tx_axis_tdata4]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlslice_15/Dout] [get_bd_pins mrmac_0/tx_axis_tdata5]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlslice_16/Dout] [get_bd_pins mrmac_0/tx_axis_tkeep_user4]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlslice_17/Dout] [get_bd_pins mrmac_0/tx_axis_tkeep_user5]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlslice_1/Dout] [get_bd_pins mrmac_0/tx_axis_tdata1]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlslice_2/Dout] [get_bd_pins mrmac_0/tx_axis_tdata2]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlslice_3/Dout] [get_bd_pins mrmac_0/tx_axis_tdata3]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlslice_4/Dout] [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlslice_5/Dout] [get_bd_pins mrmac_0/tx_axis_tkeep_user1]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlslice_6/Dout] [get_bd_pins mrmac_0/tx_axis_tkeep_user2]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlslice_7/Dout] [get_bd_pins mrmac_0/tx_axis_tkeep_user3]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces s_axi_0] [get_bd_addr_segs mrmac_0/s_axi/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""




























#####################PACKAGING MRMAC CORE#########################
file mkdir [file join [pwd] "pkg_mrmac_bd"]
ipx::package_project -root_dir [file join [pwd] "pkg_mrmac_bd"] -vendor user.org -library user -taxonomy /UserIP -module mrmac_bd -import_files
set_property ipi_drc {ignore_freq_hz false} [ipx::find_open_core user.org:user:mrmac_bd:1.0]
set_property sdx_kernel true [ipx::find_open_core user.org:user:mrmac_bd:1.0]
set_property sdx_kernel_type rtl [ipx::find_open_core user.org:user:mrmac_bd:1.0]
set_property vitis_drc {ctrl_protocol ap_ctrl_hs} [ipx::find_open_core user.org:user:mrmac_bd:1.0]
set_property vitis_drc {ctrl_protocol ap_ctrl_none} [ipx::find_open_core user.org:user:mrmac_bd:1.0]
ipx::remove_bus_parameter FREQ_HZ [ipx::get_bus_interfaces CLK_IN_D -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axi_0 -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter PHASE [ipx::get_bus_interfaces s_axi_0 -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter FREQ_HZ [ipx::get_bus_interfaces mrmac_rx -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter PHASE [ipx::get_bus_interfaces mrmac_rx -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter FREQ_HZ [ipx::get_bus_interfaces mrmac_tx -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter PHASE [ipx::get_bus_interfaces mrmac_tx -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter FREQ_HZ [ipx::get_bus_interfaces CLK.S_AXI_ACLK -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
ipx::remove_bus_parameter FREQ_HZ [ipx::get_bus_interfaces CLK.CLK_390 -of_objects [ipx::find_open_core user.org:user:mrmac_bd:1.0]]
set_property core_revision 2 [ipx::find_open_core user.org:user:mrmac_bd:1.0]
ipx::create_xgui_files [ipx::find_open_core user.org:user:mrmac_bd:1.0]
ipx::update_checksums [ipx::find_open_core user.org:user:mrmac_bd:1.0]
ipx::check_integrity -kernel -xrt [ipx::find_open_core user.org:user:mrmac_bd:1.0]
ipx::save_core [ipx::find_open_core user.org:user:mrmac_bd:1.0]
package_xo  -xo_path [file join [pwd] "xo/mrmac_bd.xo"] -kernel_name mrmac_bd -ip_directory [file join [pwd] "pkg_mrmac_bd"] -ctrl_protocol ap_ctrl_none
set_property  ip_repo_paths  [file join [pwd] "pkg_mrmac_bd"] [current_project]
update_ip_catalog
package_xo  -xo_path [file join [pwd] "xo/mrmac_bd.xo"] -kernel_name mrmac_bd -ip_directory [file join [pwd] "pkg_mrmac_bd"] -kernel_xml [file join [pwd] "mrmac_bd.xml"] -force

close_project
exit

