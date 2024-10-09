######This is a sample project for the Versal MRMAC core on the VCK5000 board########

A- Creating the MRMAC block diagram
   1- mrmac_block_design/mrmac_bd.tcl creates a block diagram for an MRMAC core in an Independent 384b Non-segmented mode in Vivado 2023.1. It has the following interfaces:
	      s_axi_0 interface is used to dynamically configure the MRMAC from the host
        GT_Serial interface for the transceiver
	      mrmac_tx interface is the axis_tx of the MRMAC core: this needs to be connected to the user logic
	      mrmac_rx interface is the axis_rx of the MRMAC core: this needs to be connected to the user logic
	      s_axi_aclk/s_axi_aresetn are used for the s_axi_0 interface
	      clk_390/resetn_390 are used for the mrmac tx and rx interfaces
	      CLK_IN_D is the GT clock
    In the current diagram, the channels tx/rx rates, and the gt_reset_all_in are connected to constants. However, you can replace the constants with gpios and dynamically assign their values from the host side. The host code for the gpios is provided in the host.cpp code in comments
   2- mrmac_block_design/mrmac_bd.xml is a file used to package the MRMAC block design into an .xo file for Vitis. After packaging the bd in Vivado, you can use the following tcl command to overwrite the generated .xo file using this .xml file: package_xo -xo_path "path_to_initial_xo_file" -kernel_name mrmac_bd -ip_directory "path_to_packaged_ip_directory" -kernel_xml "path_to_mrmac_bd.xml" -force 
   3- The provided mrmac_bd.tcl file packages the block diagram in .xo format for Vitis by default, you do not need to run step 2 in this case. However, if you want to modify the diagram, refer to step 2 for the packaging.

B- Vitis project
   To create a project with the MRMAC on the VCK5000 board: first, start a project in Vitis using the VCK5000 platform, then add the files given in the Vitis_project directory. Your project should include:
   1- A HW Kernel project that imports the mrmac_bd.xo file 
   2- Another HW Kernel project that has the user kernels connected to the mrmac_tx and mrmac_rx axis interfaces. The user kernels can be .xo RTL files or can be written in HLS. In this example, the user kernels are idle receiver and sender functions in HLS. Modify them as needed
   3- A HW Link project that imports all the files from Vitis_project/project_system_hw_link
        Change the path in the first line of bd.tcl to point to your Vitis project. Sometimes, Vitis assigns the axilite of   mrmac automatically to an address that breaks the host control, so this file ensures a proper assignment
   4- An application project for the host that imports the files from Vitis_project/host
        Change line 91 of host.cpp to point to the location of your xclbin file

The provided files contain the basic configurations and connections that enable the use of the MRMAC core, the users can add the extra logic for their applications. This design was tested by replacing the user logic with [Galapagos] (https://github.com/UofT-HPRC/galapagos) kernels and ensuring the communication with another FPGA through the network.
