#pragma once
#include <experimental/xrt_ip.h>
#include <map>
#include <string>

namespace vnx {
	struct stats_t {
		std::map<std::string, std::uint32_t> tx;
		std::map<std::string, std::uint32_t> rx;
	};

	class MRMAC {
	public:
		MRMAC(xrt::ip &mrmac);
		MRMAC(xrt::ip &&mrmac);

		void do_configure_mrmac();


	private:
		xrt::ip mrmac;

	};

	constexpr std::size_t revision_reg= 0x00000000;
	constexpr std::size_t reset_reg_0 = 0x00000004;
	constexpr std::size_t mode_reg_0 = 0x00000008;
	constexpr std::size_t configuration_tx_reg1_0 = 0x0000000C;
	constexpr std::size_t configuration_rx_reg1_0 = 0x00000010;
	constexpr std::size_t tick_reg_0 = 0x0000002C;
	constexpr std::size_t stat_rx_status_reg1_0 = 0x00000744;
	constexpr std::size_t stat_rx_rt_status_reg1_0 = 0x0000074C;
	constexpr std::size_t fec_configuration_reg1_0 = 0x000000D0;
	constexpr std::size_t fec_configuration_reg1_1 = 0x000010D0;
	constexpr std::size_t fec_configuration_reg1_2 = 0x000020D0;
	constexpr std::size_t fec_configuration_reg1_3 = 0x000030D0;

	//for port 0
	constexpr std::size_t stat_tx_total_packets_0_lsb = 0x00000818;
	constexpr std::size_t stat_tx_total_packets_0_msb = 0x0000081C;
	constexpr std::size_t stat_tx_total_good_packets_0_lsb = 0x00000820;
	constexpr std::size_t stat_tx_total_good_packets_0_msb = 0x00000824;
	constexpr std::size_t stat_tx_total_bytes_0_lsb = 0x00000828;
	constexpr std::size_t stat_tx_total_bytes_0_msb = 0x0000082C;
	constexpr std::size_t stat_tx_total_good_bytes_0_lsb = 0x00000830;
	constexpr std::size_t stat_tx_total_good_bytes_0_msb = 0x00000834;

	constexpr std::size_t stat_rx_total_packets_0_lsb = 0x00000E30;
	constexpr std::size_t stat_rx_total_packets_0_msb = 0x00000E34;
	constexpr std::size_t stat_rx_total_good_packets_0_lsb = 0x00000E38;
	constexpr std::size_t stat_rx_total_good_packets_0_msb = 0x00000E3C;
	constexpr std::size_t stat_rx_total_bytes_0_lsb = 0x00000E40;
	constexpr std::size_t stat_rx_total_bytes_0_msb = 0x00000E44;
	constexpr std::size_t stat_rx_total_good_bytes_0_lsb = 0x00000E48;
	constexpr std::size_t stat_rx_total_good_bytes_0_msb = 0x00000E4C;




}

