# Spawn-0.1.1

This repository contains a docker container for compiling and running Modelica-based code. The
configuration uses `spawn` which has been extended to compile and simulate using either
JModelica or Optimica. It can be configured to use a custom Modelica library, or by default, 
contains LBNL's Modelica Building Library (MBL) Version 8.0.

This repository also contains several examples (which are also used in the unit tests).

## Using Custom Modelica Library

By default, this image includes a specific branch of the MBL (issue2204_gmt_mbl). This can be updated
as needed by modifying the Dockerfile.

To custom build run the following:

  * Clone the modelica-buildings project into the project root, and checkout issue2204_gmt_mbl_update_spawn

    * `git clone git@github.com:lbl-srg/modelica-buildings.git`
    * `cd modelica-buildings && git checkout issue2204_gmt_mbl`

Spawn does not currently honor the MODELICAPATH env var. Use --modelica-path when calling the spawn command.
The first `--modelica-path` item needs to be the path to the package that is going to be simulations, then the
path to the library, e.g., `-modelica-path /sim/mixed_loads /sim/modelica-buildings/Buildings/`. Note the trailing `/`!

## Using the Spawn CLI
  
  * Observe the top level help, `spawn -h` and the subcommand `spawn modelica -h`
  * Copy the `*lic` license file to a location on your computer, and set the environment variable `MODELON_LICENSE_PATH` to the directory containing the license file. (Do not specify the full path to the license file.)
  * Invoke the compiler. `spawn modelica --create-fmu mixed_loads.Districts.DistrictEnergySystem --modelica-path /path/to/your/model/directory/mixed_loads --optimica`

## Building the Container

`docker build -t spawn-fmu .`

## Running the Examples

Launch a spawn-modelica container:

__**Note: Mounting files into the container don't currently work because there is a permission issue with the FMU binaries. This is on the list to be addressed by `spawn`.**__

```bash
# with Optimica license
docker run -it --rm --mac-address="<MAC_ADDRESS_OF_LICENSE>" -v $(pwd)/examples:/sim/mount spawn-fmu bash

# w/o Optimica license
docker run -it --rm -v $(pwd)/examples:/sim/mount spawn-fmu bash
```

Select an example to run from below, Flow, Load File, or Mixed Loads. The `--modelica-path` is only required if not using the built in version of the MBL.

### Flow

```bash
cd /sim/examples
spawn modelica --create-fmu Buildings.Controls.OBC.CDL.Continuous.Validation.Line --jmodelica
spawn modelica --create-fmu Buildings.Controls.OBC.CDL.Continuous.Validation.Line --optimica

# with mounted MBL
spawn modelica --create-fmu Buildings.Controls.OBC.CDL.Continuous.Validation.Line --modelica-path /sim/examples/flow /sim/modelica-buildings/Buildings/ --jmodelica

# running FMU
spawn fmu --simulate Buildings_Controls_OBC_CDL_Continuous_Validation_Line.fmu --start 0.0 --stop 3600 --step 0.01
```

### Load File

__**This file is currently not working**__

```bash
cd /sim/examples
spawn modelica --create-fmu load_example.load_file --modelica-path /sim/examples/load_example --optimica
spawn fmu --simulate load_file.fmu --start 0.0 --stop 86400 --step 3600
```

### Mixed Loads

```bash
cd /sim/examples
# Optimica
spawn modelica --create-fmu mixed_loads.Districts.DistrictEnergySystem --modelica-path /sim/examples/mixed_loads /sim/modelica-buildings/Buildings/ --optimica

# JModelica
spawn modelica --create-fmu mixed_loads.Districts.DistrictEnergySystem --modelica-path /sim/examples/mixed_loads /sim/modelica-buildings/Buildings/ --jmodelica

# running FMU
spawn fmu --simulate mixed_loads_Districts_DistrictEnergySystem.fmu --start 0.0 --stop 86400 --step 300
```

## Running the Tests

Run the tests with `py.test -s`. The `-s` is required to prevent the TTY error and turn off capture.

