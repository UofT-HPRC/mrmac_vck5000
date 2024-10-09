#include <iostream>
#include <cstring>
#include <thread>
#include <chrono>

#include <experimental/xrt_bo.h>
#include <experimental/xrt_device.h>
#include <experimental/xrt_kernel.h>
#include <experimental/xrt_ip.h>
#include <bitset>
#include <map>
#include <string>

#include "mrmac.hpp"



namespace vnx {
	MRMAC::MRMAC(xrt::ip &mrmac) : mrmac(mrmac) {}
	MRMAC::MRMAC(xrt::ip &&mrmac) : mrmac(mrmac) {}

	void MRMAC::do_configure_mrmac() {
		uint32_t mrmac_core_ver_reg = mrmac.read_register(revision_reg);
		printf("MRMAC Core Version = %x \n", mrmac_core_ver_reg);

		mrmac.write_register(reset_reg_0, 0X0000FFF);
		printf("1 reset_reg_0 %x \n", mrmac.read_register(reset_reg_0));
		mrmac.write_register(mode_reg_0, 0x40000A64);
		printf("2 mode_reg_0 %x \n", mrmac.read_register(mode_reg_0));
		mrmac.write_register(configuration_rx_reg1_0, 0x00000033);
		printf("3 configuration_rx_reg1_0 %x \n", mrmac.read_register(configuration_rx_reg1_0));
		mrmac.write_register(configuration_tx_reg1_0, 0x00000C03);
		printf("4 configuration_tx_reg1_0 %x \n", mrmac.read_register(configuration_tx_reg1_0));
		mrmac.write_register(fec_configuration_reg1_0, 0x00000000);
		printf("5 fec_configuration_reg1_0 %x \n", mrmac.read_register(fec_configuration_reg1_0));
		mrmac.write_register(fec_configuration_reg1_1, 0x00000000);
		printf("6 fec_configuration_reg1_1 %x \n", mrmac.read_register(fec_configuration_reg1_1));
		mrmac.write_register(fec_configuration_reg1_2, 0x00000000);
		printf("7 fec_configuration_reg1_2 %x \n", mrmac.read_register(fec_configuration_reg1_2));
		mrmac.write_register(fec_configuration_reg1_3, 0x00000000);
		printf("8 fec_configuration_reg1_3 %x \n", mrmac.read_register(fec_configuration_reg1_3));
		mrmac.write_register(reset_reg_0, 0x00000000);
		printf("9 reset_reg_0 %x \n", mrmac.read_register(reset_reg_0));
		mrmac.write_register(tick_reg_0 , 0x00000001);
		printf("10 tick_reg_0 %x \n", mrmac.read_register(tick_reg_0));
		printf("waiting  for 15 seconds to reset done \n");
		std::this_thread::sleep_for(std::chrono::seconds(15));
		/*
		// Check value of reset done out if you are using a gpio
		uint32_t stat_mst_reset_done_reg = gpio.read_register(0x8);
			printf("rx reset done value: %x \n", stat_mst_reset_done_reg);
			while (stat_mst_reset_done_reg == 0) {
				stat_mst_reset_done_reg = gpio.read_register(0x8);
				std::this_thread::sleep_for(std::chrono::seconds(1));
			}
			printf("reset done in configure %x \n", stat_mst_reset_done_reg);
		*/
		printf("INFO: Polling on RX aligned \n");
		uint32_t rx_align_num_attempts =0;
		mrmac.write_register(stat_rx_status_reg1_0,  0xFFFFFFFF);
		uint32_t rx_status_reg1_0_reg = mrmac.read_register(stat_rx_status_reg1_0);
		while (!(rx_status_reg1_0_reg & 0x00000001) || !(rx_status_reg1_0_reg & 0x00000002) | !(rx_status_reg1_0_reg & 0x00000004)) {
			if (rx_align_num_attempts >= 20) {
				printf("RX Aignment timeout \n");
				return;
			}
			else if (rx_status_reg1_0_reg & 0x00020000) {
				printf("RX Synced error of mrmac \n");
				return;
			}
			rx_align_num_attempts ++;
			printf("Polling on MRMAC RX align reg: %x \n",rx_status_reg1_0_reg);
			mrmac.write_register(stat_rx_status_reg1_0 , 0xFFFFFFFF);
			rx_status_reg1_0_reg = mrmac.read_register(stat_rx_status_reg1_0);

			std::this_thread::sleep_for(std::chrono::seconds(1));
		}
		printf("RX Align status reg: %x \n", rx_status_reg1_0_reg);


	}

}


int main(int argc, char** argv){

	std::cout <<"Open the device\n"<< std::endl;
	auto device = xrt::device(0);
	std::cout <<"Load the xclbin\n"<<std::endl;
	auto uuid = device.load_xclbin("/path_to_project_system/Hardware/binary_container_1.xclbin");


	auto mrmac = xrt::ip(device, uuid, "mrmac_bd");



	/* If You need to use GPIOS to set the channels rate and assign the gt_reset
        // Here gpio is connected to gt_reset_all_in input and the gt_rx_reset_done_out
	// and gpio_2 is connected to 
	auto gpio = xrt::ip(device, uuid, "gpio");
	auto gpio_2 = xrt::ip(device, uuid, "gpio_2");

	//SET gt_line_rate to 0
	gpio_2.write_register(0x4, 0);
	gpio_2.write_register(0x0, 0);

	//SET gt_reset_all_in
	gpio.write_register(0x4, 0);
	gpio.write_register(0xC, 1);
	gpio.write_register(0x0, 0);
	gpio.write_register(0x0, 0xF);
	gpio.write_register(0x0, 0x0);

	std::this_thread::sleep_for(std::chrono::seconds(15));

	uint32_t reset_done = gpio.read_register(0x8);
	printf("rx reset done value: %x \n", reset_done);
	while (reset_done == 0) {
		reset_done = gpio.read_register(0x8);
		std::this_thread::sleep_for(std::chrono::seconds(1));
	}
	printf("reset done 1 %x \n", reset_done);


	//SET gt_line_rate to 2
	gpio_2.write_register(0x0, 2);
	gpio.write_register(0x0, 0x0);;
	gpio.write_register(0x0, 0xF);
	gpio.write_register(0x0, 0x0);

	std::this_thread::sleep_for(std::chrono::seconds(15));

	reset_done = gpio.read_register(0x8);
	while (reset_done == 0) {
		reset_done = gpio.read_register(0x8);
	}
	printf("reset done 2 %x \n", reset_done);
	*/

	vnx::MRMAC mrmac_class(mrmac);


    	mrmac_class.do_configure_mrmac();

	// Add the control for your kernels here




	return 0;

}

