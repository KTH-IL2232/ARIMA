# ARIMA-Based-Dnomaly-Detection-Hardware-Implementation
assistant code:
    python:  
        anomaly_detection_on_ArticicialData.py: is full implementation of ARIMA based anomaly detection.
        dataset_generate: generate articifical data time series and manually insert anomaly points.(data used in python)
        generate_fixed_point_binary_testdata: generate articifical data time series and manually insert anomaly points.(data used in RTL,fixed point data)
    c: 
        inference.cpp: ARIMA inference implementation.(Big difference from python statsmodels library is no kalman filter implemented)

core code:
    rtl: 
        anomaly_detection.sv: anomaly_detector.
        ar_n.sv: AR module.
        clock_divider.vhd: clock divider used in FPGA implementation.
        datapath_n.sv: datapath.
        diff_n.sv: difference module.
        hex_to_seg.sv: seven segment display used in FPGA implementation.
        integral_new.sv: integral module.
        ma_n.sv: ma module.
        qmult.sv: fixed point multiplier.
        top.sv: top ARIMA anomaly detector without bram ip and peripherals.
        top_fpga.sv: top fpga design with bram ip and peripherals.
        top_FSM.sv: control logic.
    testbench:
        tb_top_ad_fake_ram.sv: testbench for top design with fake ram
        tb_top_with_bram.sv: testbench for top design with bram ip
    ip:
        blk_mem_gen_0.xci: BRAM ip generated by vivado
    coe_file:
        coeficient file used to initialize BRAM ip
    constraints:
        vivado xdc file used to set clock period and port connection

fig:
    some figures about the design
