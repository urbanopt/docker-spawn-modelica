import pytest
import os


value = None 

class TestCompile:
    @classmethod
    def setup_class(cls):
        print('*****SETUP*****')

        # If using optimica then set the mac address which is needed for the license
        mac_address = os.getenv('MAC_ADDRESS', None)
        if mac_address:
            cls.docker_prepend_str = f"docker run -it --rm --mac-address={mac_address} spawn-fmu"
        else:
            cls.docker_prepend_str = f"docker run -it --rm spawn-fmu"

        # build the docker container from the root directory
        print(os.curdir)
        os.system("docker build -t spawn-fmu .")

    @classmethod
    def teardown_class(cls):
        print('******TEARDOWN******') 
        
    # def test_mixed_model(self):
    #     # mixed_loads require custom version of the Modelica Buildings Library (issue2204_gmt_mbl)
    #     sim_command = "spawn modelica --create-fmu mixed_loads.Districts.DistrictEnergySystem --modelica-path /sim/examples/mixed_loads /sim/modelica-buildings/Buildings/ --jmodelica"
    #     sim_command += " && spawn fmu --simulate mixed_loads_Districts_DistrictEnergySystem.fmu --start 0.0 --stop 86400 --step 300"
    #     run_command = f"{self.docker_prepend_str} /bin/bash -c '{sim_command}'"
        
    #     print(f"Running {run_command}")
    #     r = os.system(run_command)

    #     assert r == 0

    def test_flow_model(self):
        compiler = '--optimica'
        sim_command = f"spawn modelica --create-fmu Buildings.Controls.OBC.CDL.Continuous.Validation.Line --modelica-path /sim/examples/flow {compiler}"
        sim_command += " && spawn fmu --simulate Buildings_Controls_OBC_CDL_Continuous_Validation_Line.fmu --start 0.0 --stop 3600 --step 0.01"
        run_command = f"{self.docker_prepend_str} /bin/bash -c '{sim_command}'"
        
        print(f"Running {run_command}")
        r = os.system(run_command)

        # we aren't currently checking the results of the simulations, just the exit code
        assert r == 0

        compiler = '--jmodelica'
        sim_command = f"spawn modelica --create-fmu Buildings.Controls.OBC.CDL.Continuous.Validation.Line --modelica-path /sim/examples/flow {compiler}"
        sim_command += " && spawn fmu --simulate Buildings_Controls_OBC_CDL_Continuous_Validation_Line.fmu --start 0.0 --stop 3600 --step 0.01"
        run_command = f"{self.docker_prepend_str} /bin/bash -c '{sim_command}'"
        
        print(f"Running {run_command}")
        r = os.system(run_command)
        
        assert r == 0


