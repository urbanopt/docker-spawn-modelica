within mixed_loads.Districts;
model DistrictEnergySystem
  extends Modelica.Icons.Example;
  // District Parameters
  package MediumW=Buildings.Media.Water
    "Source side medium";
  package MediumA=Buildings.Media.Air
    "Load side medium";

  // TODO: dehardcode? Also, add display units to the other parameters.
  parameter Modelica.SIunits.TemperatureDifference delChiWatTemDis(displayUnit="degC")=7;
  parameter Modelica.SIunits.TemperatureDifference delChiWatTemBui=5;
  parameter Modelica.SIunits.TemperatureDifference delHeaWatTemDis=12;
  parameter Modelica.SIunits.TemperatureDifference delHeaWatTemBui=5;

  // Models

  //
  // Begin Model Instance for disNet_61afc0e4
  // Source template: /model_connectors/networks/templates/Network2Pipe_Instance.mopt
  //
parameter Integer nBui_disNet_61afc0e4=2;
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal_disNet_61afc0e4=sum({
    cooInd_4a48b99b.mDis_flow_nominal,
  cooInd_0844b396.mDis_flow_nominal})
    "Nominal mass flow rate of the distribution pump";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal_disNet_61afc0e4[nBui_disNet_61afc0e4]={
    cooInd_4a48b99b.mDis_flow_nominal,
  cooInd_0844b396.mDis_flow_nominal}
    "Nominal mass flow rate in each connection line";
  parameter Modelica.SIunits.PressureDifference dpDis_nominal_disNet_61afc0e4[nBui_disNet_61afc0e4](
    each min=0,
    each displayUnit="Pa")=1/2 .* cat(
    1,
    {dp_nominal_disNet_61afc0e4*0.1},
    fill(
      dp_nominal_disNet_61afc0e4*0.9/(nBui_disNet_61afc0e4-1),
      nBui_disNet_61afc0e4-1))
    "Pressure drop between each connected building at nominal conditions (supply line)";
  parameter Modelica.SIunits.PressureDifference dp_nominal_disNet_61afc0e4=dpSetPoi_disNet_61afc0e4+nBui_disNet_61afc0e4*7000
    "District network pressure drop";
  // NOTE: this differential pressure setpoint is currently utilized by plants elsewhere
  parameter Modelica.SIunits.Pressure dpSetPoi_disNet_61afc0e4=50000
    "Differential pressure setpoint";

  Buildings.Experimental.DHC.Loads.Validation.BaseClasses.Distribution2Pipe disNet_61afc0e4(
    redeclare final package Medium=MediumW,
    final nCon=nBui_disNet_61afc0e4,
    iConDpSen=nBui_disNet_61afc0e4,
    final mDis_flow_nominal=mDis_flow_nominal_disNet_61afc0e4,
    final mCon_flow_nominal=mCon_flow_nominal_disNet_61afc0e4,
    final allowFlowReversal=false,
    dpDis_nominal=dpDis_nominal_disNet_61afc0e4)
    "Distribution network."
    annotation (Placement(transformation(extent={{-30.0,120.0},{-10.0,130.0}})));
  //
  // End Model Instance for disNet_61afc0e4
  //


  
  //
  // Begin Model Instance for cooPla_cda7f1b9
  // Source template: /model_connectors/plants/templates/CoolingPlant_Instance.mopt
  //
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal_cooPla_cda7f1b9=cooPla_cda7f1b9.numChi*(cooPla_cda7f1b9.perChi.mEva_flow_nominal)
    "Nominal chilled water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal_cooPla_cda7f1b9=cooPla_cda7f1b9.perChi.mCon_flow_nominal
    "Nominal condenser water mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpCHW_nominal_cooPla_cda7f1b9=44.8*1000
    "Nominal chilled water side pressure";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal_cooPla_cda7f1b9=46.2*1000
    "Nominal condenser water side pressure";
  parameter Modelica.SIunits.Power QEva_nominal_cooPla_cda7f1b9=mCHW_flow_nominal_cooPla_cda7f1b9*4200*(5-14)
    "Nominal cooling capaciaty (Negative means cooling)";
  parameter Modelica.SIunits.MassFlowRate mMin_flow_cooPla_cda7f1b9=0.2*mCHW_flow_nominal_cooPla_cda7f1b9/cooPla_cda7f1b9.numChi
    "Minimum mass flow rate of single chiller";
  // control settings
  parameter Modelica.SIunits.Pressure dpSetPoi_cooPla_cda7f1b9=70000
    "Differential pressure setpoint";
  parameter Modelica.SIunits.Pressure pumDP_cooPla_cda7f1b9=dpCHW_nominal_cooPla_cda7f1b9+dpSetPoi_cooPla_cda7f1b9+200000;
  parameter Modelica.SIunits.Time tWai_cooPla_cda7f1b9=30
    "Waiting time";
  // pumps
  parameter Buildings.Fluid.Movers.Data.Generic perCHWPum_cooPla_cda7f1b9(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=((mCHW_flow_nominal_cooPla_cda7f1b9/cooPla_cda7f1b9.numChi)/1000)*{0.1,1,1.2},
      dp=pumDP_cooPla_cda7f1b9*{1.2,1,0.1}))
    "Performance data for chilled water pumps";
  parameter Buildings.Fluid.Movers.Data.Generic perCWPum_cooPla_cda7f1b9(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mCW_flow_nominal_cooPla_cda7f1b9/1000*{0.2,0.6,1.0,1.2},
      dp=(dpCW_nominal_cooPla_cda7f1b9+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps";


  Modelica.Blocks.Sources.RealExpression TSetChiWatDis_cooPla_cda7f1b9(
    y=5+273.15)
    "Chilled water supply temperature set point on district level."
    annotation (Placement(transformation(extent={{10.0,-130.0},{30.0,-110.0}})));
  Modelica.Blocks.Sources.BooleanConstant on_cooPla_cda7f1b9
    "On signal of the plant"
    annotation (Placement(transformation(extent={{50.0,-130.0},{70.0,-110.0}})));

  mixed_loads.Plants.CentralCoolingPlant cooPla_cda7f1b9(
    redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19EX_5208kW_6_88COP_Vanes perChi,
    perCHWPum=perCHWPum_cooPla_cda7f1b9,
    perCWPum=perCWPum_cooPla_cda7f1b9,
    mCHW_flow_nominal=mCHW_flow_nominal_cooPla_cda7f1b9,
    dpCHW_nominal=dpCHW_nominal_cooPla_cda7f1b9,
    QEva_nominal=QEva_nominal_cooPla_cda7f1b9,
    mMin_flow=mMin_flow_cooPla_cda7f1b9,
    mCW_flow_nominal=mCW_flow_nominal_cooPla_cda7f1b9,
    dpCW_nominal=dpCW_nominal_cooPla_cda7f1b9,
    TAirInWB_nominal=298.7,
    TCW_nominal=308.15,
    TMin=288.15,
    tWai=tWai_cooPla_cda7f1b9,
    dpSetPoi=dpSetPoi_cooPla_cda7f1b9,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "District cooling plant."
    annotation (Placement(transformation(extent={{-70.0,110.0},{-50.0,130.0}})));
  //
  // End Model Instance for cooPla_cda7f1b9
  //


  
  //
  // Begin Model Instance for disNet_249a1248
  // Source template: /model_connectors/networks/templates/Network2Pipe_Instance.mopt
  //
parameter Integer nBui_disNet_249a1248=2;
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal_disNet_249a1248=sum({
    heaInd_a5839ad4.mDis_flow_nominal,
  heaInd_e75dd196.mDis_flow_nominal})
    "Nominal mass flow rate of the distribution pump";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal_disNet_249a1248[nBui_disNet_249a1248]={
    heaInd_a5839ad4.mDis_flow_nominal,
  heaInd_e75dd196.mDis_flow_nominal}
    "Nominal mass flow rate in each connection line";
  parameter Modelica.SIunits.PressureDifference dpDis_nominal_disNet_249a1248[nBui_disNet_249a1248](
    each min=0,
    each displayUnit="Pa")=1/2 .* cat(
    1,
    {dp_nominal_disNet_249a1248*0.1},
    fill(
      dp_nominal_disNet_249a1248*0.9/(nBui_disNet_249a1248-1),
      nBui_disNet_249a1248-1))
    "Pressure drop between each connected building at nominal conditions (supply line)";
  parameter Modelica.SIunits.PressureDifference dp_nominal_disNet_249a1248=dpSetPoi_disNet_249a1248+nBui_disNet_249a1248*7000
    "District network pressure drop";
  // NOTE: this differential pressure setpoint is currently utilized by plants elsewhere
  parameter Modelica.SIunits.Pressure dpSetPoi_disNet_249a1248=50000
    "Differential pressure setpoint";

  Buildings.Experimental.DHC.Loads.Validation.BaseClasses.Distribution2Pipe disNet_249a1248(
    redeclare final package Medium=MediumW,
    final nCon=nBui_disNet_249a1248,
    iConDpSen=nBui_disNet_249a1248,
    final mDis_flow_nominal=mDis_flow_nominal_disNet_249a1248,
    final mCon_flow_nominal=mCon_flow_nominal_disNet_249a1248,
    final allowFlowReversal=false,
    dpDis_nominal=dpDis_nominal_disNet_249a1248)
    "Distribution network."
    annotation (Placement(transformation(extent={{-30.0,80.0},{-10.0,90.0}})));
  //
  // End Model Instance for disNet_249a1248
  //


  
  //
  // Begin Model Instance for heaPla70ff66d6
  // Source template: /model_connectors/plants/templates/HeatingPlant_Instance.mopt
  //
  // heating plant instance
  parameter Modelica.SIunits.MassFlowRate mHW_flow_nominal_heaPla70ff66d6=mBoi_flow_nominal_heaPla70ff66d6*heaPla70ff66d6.numBoi
    "Nominal heating water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal_heaPla70ff66d6=QBoi_nominal_heaPla70ff66d6/(4200*heaPla70ff66d6.delT_nominal)
    "Nominal heating water mass flow rate";
  parameter Modelica.SIunits.Power QBoi_nominal_heaPla70ff66d6=Q_flow_nominal_heaPla70ff66d6/heaPla70ff66d6.numBoi
    "Nominal heating capaciaty";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_heaPla70ff66d6=1000000*2
    "Heating load";
  parameter Modelica.SIunits.MassFlowRate mMin_flow_heaPla70ff66d6=0.2*mBoi_flow_nominal_heaPla70ff66d6
    "Minimum mass flow rate of single boiler";
  // controls
  parameter Modelica.SIunits.Pressure pumDP=(heaPla70ff66d6.dpBoi_nominal+dpSetPoi_disNet_249a1248+50000)
    "Heating water pump pressure drop";
  parameter Modelica.SIunits.Time tWai_heaPla70ff66d6=30
    "Waiting time";
  parameter Buildings.Fluid.Movers.Data.Generic perHWPum_heaPla70ff66d6(
    pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
      V_flow=mBoi_flow_nominal_heaPla70ff66d6/1000*{0.1,1.1},
      dp=pumDP*{1.1,0.1}))
    "Performance data for heating water pumps";

  mixed_loads.Plants.CentralHeatingPlant heaPla70ff66d6(
    perHWPum=perHWPum_heaPla70ff66d6,
    mHW_flow_nominal=mHW_flow_nominal_heaPla70ff66d6,
    QBoi_flow_nominal=QBoi_nominal_heaPla70ff66d6,
    mMin_flow=mMin_flow_heaPla70ff66d6,
    mBoi_flow_nominal=mBoi_flow_nominal_heaPla70ff66d6,
    dpBoi_nominal=10000,
    delT_nominal(
      displayUnit="degC")=15,
    tWai=tWai_heaPla70ff66d6,
    // TODO: we're currently grabbing dpSetPoi from the Network instance -- need feedback to determine if that's the proper "home" for it
    dpSetPoi=dpSetPoi_disNet_249a1248,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "District heating plant."
    annotation (Placement(transformation(extent={{-70.0,70.0},{-50.0,90.0}})));
  //
  // End Model Instance for heaPla70ff66d6
  //


  
  //
  // Begin Model Instance for TimeSerLoa_166f107f
  // Source template: /model_connectors/load_connectors/templates/TimeSeries_Instance.mopt
  //
  // time series load
  mixed_loads.Loads.timeSeriesID.building TimeSerLoa_166f107f(
    T_aHeaWat_nominal=318.15,
    T_aChiWat_nominal=280.15,
    delTAirCoo(displayUnit="degC")=10,
    delTAirHea(displayUnit="degC")=20,
    k=0.1,
    Ti=120,
    nPorts_bChiWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_aHeaWat=1)
    "Building model integrating multiple time series thermal zones."
    annotation (Placement(transformation(extent={{50.0,110.0},{70.0,130.0}})));
  //
  // End Model Instance for TimeSerLoa_166f107f
  //


  
  //
  // Begin Model Instance for cooInd_4a48b99b
  // Source template: /model_connectors/energy_transfer_systems/templates/CoolingIndirect_Instance.mopt
  //
  // cooling indirect instance
  mixed_loads.Substations.CoolingIndirect_timeSeriesID cooInd_4a48b99b(
    redeclare package Medium=MediumW,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    mDis_flow_nominal=mDis_flow_nominal_f71f3c07,
    mBui_flow_nominal=mBui_flow_nominal_f71f3c07,
    dp1_nominal=500,
    dp2_nominal=500,
    dpValve_nominal=7000,
    use_Q_flow_nominal=true,
    Q_flow_nominal=Q_flow_nominal_f71f3c07,
    // TODO: dehardcode the nominal temperatures?
    T_a1_nominal=273.15+5,
    T_a2_nominal=273.15+13)
    "Indirect cooling energy transfer station ETS."
    annotation (Placement(transformation(extent={{10.0,110.0},{30.0,130.0}})));
  //
  // End Model Instance for cooInd_4a48b99b
  //


  
  //
  // Begin Model Instance for heaInd_a5839ad4
  // Source template: /model_connectors/energy_transfer_systems/templates/HeatingIndirect_Instance.mopt
  //
  // heating indirect instance
  mixed_loads.Substations.HeatingIndirect_timeSeriesID heaInd_a5839ad4(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    show_T=true,
    redeclare package Medium=MediumW,
    mDis_flow_nominal=mDis_flow_nominal_c31184ec,
    mBui_flow_nominal=mBui_flow_nominal_c31184ec,
    dpValve_nominal=6000,
    dp1_nominal=500,
    dp2_nominal=500,
    use_Q_flow_nominal=true,
    Q_flow_nominal=Q_flow_nominal_c31184ec,
    T_a1_nominal=55+273.15,
    T_a2_nominal=35+273.15,
    k=0.1,
    Ti=60,
    reverseActing=true)
    annotation (Placement(transformation(extent={{10.0,70.0},{30.0,90.0}})));
  //
  // End Model Instance for heaInd_a5839ad4
  //


  
  //
  // Begin Model Instance for TeaserLoad_e7825bcc
  // Source template: /model_connectors/load_connectors/templates/Teaser_Instance.mopt
  //
  mixed_loads.Loads.teaserID.building TeaserLoad_e7825bcc(
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1)
    "Building with thermal loads as TEASER zones"
    annotation (Placement(transformation(extent={{50.0,30.0},{70.0,50.0}})));
  //
  // End Model Instance for TeaserLoad_e7825bcc
  //


  
  //
  // Begin Model Instance for cooInd_0844b396
  // Source template: /model_connectors/energy_transfer_systems/templates/CoolingIndirect_Instance.mopt
  //
  // cooling indirect instance
  mixed_loads.Substations.CoolingIndirect_teaserID cooInd_0844b396(
    redeclare package Medium=MediumW,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    mDis_flow_nominal=mDis_flow_nominal_0650fc70,
    mBui_flow_nominal=mBui_flow_nominal_0650fc70,
    dp1_nominal=500,
    dp2_nominal=500,
    dpValve_nominal=7000,
    use_Q_flow_nominal=true,
    Q_flow_nominal=Q_flow_nominal_0650fc70,
    // TODO: dehardcode the nominal temperatures?
    T_a1_nominal=273.15+5,
    T_a2_nominal=273.15+13)
    "Indirect cooling energy transfer station ETS."
    annotation (Placement(transformation(extent={{10.0,30.0},{30.0,50.0}})));
  //
  // End Model Instance for cooInd_0844b396
  //


  
  //
  // Begin Model Instance for heaInd_e75dd196
  // Source template: /model_connectors/energy_transfer_systems/templates/HeatingIndirect_Instance.mopt
  //
  // heating indirect instance
  mixed_loads.Substations.HeatingIndirect_teaserID heaInd_e75dd196(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    show_T=true,
    redeclare package Medium=MediumW,
    mDis_flow_nominal=mDis_flow_nominal_cc6ef5c7,
    mBui_flow_nominal=mBui_flow_nominal_cc6ef5c7,
    dpValve_nominal=6000,
    dp1_nominal=500,
    dp2_nominal=500,
    use_Q_flow_nominal=true,
    Q_flow_nominal=Q_flow_nominal_cc6ef5c7,
    T_a1_nominal=55+273.15,
    T_a2_nominal=35+273.15,
    k=0.1,
    Ti=60,
    reverseActing=true)
    annotation (Placement(transformation(extent={{10.0,-10.0},{30.0,10.0}})));
  //
  // End Model Instance for heaInd_e75dd196
  //


  

  // Model dependencies

  //
  // Begin Component Definitions for 80db10e1
  // Source template: /model_connectors/couplings/templates/Network2Pipe_CoolingPlant/ComponentDefinitions.mopt
  //
  // No components for pipe and cooling plant

  //
  // End Component Definitions for 80db10e1
  //



  //
  // Begin Component Definitions for 9ba377dd
  // Source template: /model_connectors/couplings/templates/Network2Pipe_HeatingPlant/ComponentDefinitions.mopt
  //
  // TODO: This should not be here, it is entirely plant specific and should be moved elsewhere
  // but since it requires a connect statement we must put it here for now...
  Modelica.Blocks.Sources.BooleanConstant mPum_flow_9ba377dd(
    k=true)
    "Total heating water pump mass flow rate"
    annotation (Placement(transformation(extent={{-70.0,-50.0},{-50.0,-30.0}})));
  // TODO: This should not be here, it is entirely plant specific and should be moved elsewhere
  // but since it requires a connect statement we must put it here for now...
  Modelica.Blocks.Sources.RealExpression TDisSetHeaWat_9ba377dd(
    each y=273.15+54)
    "District side heating water supply temperature set point."
    annotation (Placement(transformation(extent={{-30.0,-50.0},{-10.0,-30.0}})));

  //
  // End Component Definitions for 9ba377dd
  //



  //
  // Begin Component Definitions for f71f3c07
  // Source template: /model_connectors/couplings/templates/TimeSeries_CoolingIndirect/ComponentDefinitions.mopt
  //
  // TimeSeries + CoolingIndirect Component Definitions
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal_f71f3c07=TimeSerLoa_166f107f.mChiWat_flow_nominal*delChiWatTemBui/delChiWatTemDis
    "Nominal mass flow rate of primary (district) district cooling side";
  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal_f71f3c07=TimeSerLoa_166f107f.mChiWat_flow_nominal
    "Nominal mass flow rate of secondary (building) district cooling side";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_f71f3c07=-1*(TimeSerLoa_166f107f.QCoo_flow_nominal);
  Modelica.Fluid.Sources.FixedBoundary pressure_source_f71f3c07(
    redeclare package Medium=MediumW,
    use_T=false,
    nPorts=1)
    "Pressure source"
    annotation (Placement(transformation(extent={{10.0,-50.0},{30.0,-30.0}})));
  // TODO: move TChiWatSet (and its connection) into a CoolingIndirect specific template file (this component does not depend on the coupling)
  Modelica.Blocks.Sources.RealExpression TChiWatSet_f71f3c07(
    y=7+273.15)
    //Dehardcode
    "Primary loop (district side) chilled water setpoint temperature."
    annotation (Placement(transformation(extent={{50.0,-50.0},{70.0,-30.0}})));

  //
  // End Component Definitions for f71f3c07
  //



  //
  // Begin Component Definitions for 96e60a9b
  // Source template: /model_connectors/couplings/templates/CoolingIndirect_Network2Pipe/ComponentDefinitions.mopt
  //
  // no component definitions for cooling indirect and network 2 pipe

  //
  // End Component Definitions for 96e60a9b
  //



  //
  // Begin Component Definitions for c31184ec
  // Source template: /model_connectors/couplings/templates/TimeSeries_HeatingIndirect/ComponentDefinitions.mopt
  //
  // TimeSeries + HeatingIndirect Component Definitions
  // TODO: the components below need to be fixed!
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal_c31184ec=TimeSerLoa_166f107f.mHeaWat_flow_nominal*delHeaWatTemBui/delHeaWatTemDis
    "Nominal mass flow rate of primary (district) district heating side";
  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal_c31184ec=TimeSerLoa_166f107f.mHeaWat_flow_nominal
    "Nominal mass flow rate of secondary (building) district heating side";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_c31184ec=(TimeSerLoa_166f107f.QHea_flow_nominal);
  Modelica.Fluid.Sources.FixedBoundary pressure_source_c31184ec(
    redeclare package Medium=MediumW,
    use_T=false,
    nPorts=1)
    "Pressure source"
    annotation (Placement(transformation(extent={{-70.0,-90.0},{-50.0,-70.0}})));
  // TODO: move THeaWatSet (and its connection) into a HeatingIndirect specific template file (this component does not depend on the coupling)
  Modelica.Blocks.Sources.RealExpression THeaWatSet_c31184ec(
    // y=40+273.15)
    y=273.15+40 )
    "Secondary loop (Building side) heating water setpoint temperature."
    //Dehardcode
    annotation (Placement(transformation(extent={{-30.0,-90.0},{-10.0,-70.0}})));

  //
  // End Component Definitions for c31184ec
  //



  //
  // Begin Component Definitions for e2e23d71
  // Source template: /model_connectors/couplings/templates/HeatingIndirect_Network2Pipe/ComponentDefinitions.mopt
  //
  // no component definitions for heating indirect and network 2 pipe

  //
  // End Component Definitions for e2e23d71
  //



  //
  // Begin Component Definitions for 0650fc70
  // Source template: /model_connectors/couplings/templates/Teaser_CoolingIndirect/ComponentDefinitions.mopt
  //
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal_0650fc70=TeaserLoad_e7825bcc.disFloCoo.m_flow_nominal*delChiWatTemBui/delChiWatTemDis
    "Nominal mass flow rate of primary (district) district cooling side"; // TODO: verify this is ok!
  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal_0650fc70=TeaserLoad_e7825bcc.terUni[1].mChiWat_flow_nominal
    "Nominal mass flow rate of secondary (building) district cooling side"; // TODO: verify this is ok!
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_0650fc70=-1*TeaserLoad_e7825bcc.terUni[1].QHea_flow_nominal; // TODO: verify this is ok!
  Modelica.Fluid.Sources.FixedBoundary pressure_source_0650fc70(
    redeclare package Medium=MediumW,
    use_T=false,
    nPorts=1)
    "Pressure source"
    annotation (Placement(transformation(extent={{10.0,-90.0},{30.0,-70.0}})));
  // TODO: move TChiWatSet (and its connection) into a CoolingIndirect specific template file (this component does not depend on the coupling)
  Modelica.Blocks.Sources.RealExpression TChiWatSet_0650fc70(
    y=7+273.15)
    //Dehardcode
    "Primary loop (district side) chilled water setpoint temperature."
    annotation (Placement(transformation(extent={{50.0,-90.0},{70.0,-70.0}})));

  //
  // End Component Definitions for 0650fc70
  //



  //
  // Begin Component Definitions for 58ff9e9b
  // Source template: /model_connectors/couplings/templates/CoolingIndirect_Network2Pipe/ComponentDefinitions.mopt
  //
  // no component definitions for cooling indirect and network 2 pipe

  //
  // End Component Definitions for 58ff9e9b
  //



  //
  // Begin Component Definitions for cc6ef5c7
  // Source template: /model_connectors/couplings/templates/Teaser_HeatingIndirect/ComponentDefinitions.mopt
  //
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal_cc6ef5c7=TeaserLoad_e7825bcc.disFloHea.m_flow_nominal*delHeaWatTemBui/delHeaWatTemDis
    "Nominal mass flow rate of primary (district) district heating side"; // TODO: Verify this is ok!
  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal_cc6ef5c7=TeaserLoad_e7825bcc.terUni[1].mHeaWat_flow_nominal
    "Nominal mass flow rate of secondary (building) district heating side"; // TODO: Verify this is ok!
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_cc6ef5c7=TeaserLoad_e7825bcc.terUni[1].QHea_flow_nominal; // TODO: Verify this is ok!
  Modelica.Fluid.Sources.FixedBoundary pressure_source_cc6ef5c7(
    redeclare package Medium=MediumW,
    use_T=false,
    nPorts=1)
    "Pressure source"
    annotation (Placement(transformation(extent={{-70.0,-130.0},{-50.0,-110.0}})));
  // TODO: move THeaWatSet (and its connection) into a HeatingIndirect specific template file (this component does not depend on the coupling)
  Modelica.Blocks.Sources.RealExpression THeaWatSet_cc6ef5c7(
    // y=40+273.15)
    y=273.15+40)
    "Secondary loop (Building side) heating water setpoint temperature."
    //Dehardcode
    annotation (Placement(transformation(extent={{-30.0,-130.0},{-10.0,-110.0}})));

  //
  // End Component Definitions for cc6ef5c7
  //



  //
  // Begin Component Definitions for c3623bb1
  // Source template: /model_connectors/couplings/templates/HeatingIndirect_Network2Pipe/ComponentDefinitions.mopt
  //
  // no component definitions for heating indirect and network 2 pipe

  //
  // End Component Definitions for c3623bb1
  //



equation
  // Connections

  //
  // Begin Connect Statements for 80db10e1
  // Source template: /model_connectors/couplings/templates/Network2Pipe_CoolingPlant/ConnectStatements.mopt
  //

  // TODO: these connect statements shouldn't be here, they are plant specific
  // but since we can't currently make connect statements for single systems, this is what we've got
  connect(on_cooPla_cda7f1b9.y,cooPla_cda7f1b9.on)
    annotation (Line(points={{67.31924708438115,-92.26059464689234},{47.319247084381146,-92.26059464689234},{47.319247084381146,-72.26059464689234},{47.319247084381146,-52.26059464689234},{47.319247084381146,-32.26059464689234},{47.319247084381146,-12.260594646892343},{47.319247084381146,7.7394053531076565},{47.319247084381146,27.739405353107657},{47.319247084381146,47.73940535310766},{47.319247084381146,67.73940535310766},{47.319247084381146,87.73940535310766},{47.319247084381146,107.73940535310766},{27.31924708438116,107.73940535310766},{7.319247084381161,107.73940535310766},{-12.68075291561884,107.73940535310766},{-32.68075291561884,107.73940535310766},{-32.68075291561884,127.73940535310766},{-52.68075291561884,127.73940535310766}},color={0,0,127}));
  connect(TSetChiWatDis_cooPla_cda7f1b9.y,cooPla_cda7f1b9.TCHWSupSet)
    annotation (Line(points={{21.102848082856568,-98.78541429931792},{1.1028480828565677,-98.78541429931792},{1.1028480828565677,-78.78541429931792},{1.1028480828565677,-58.78541429931792},{1.1028480828565677,-38.78541429931792},{1.1028480828565677,-18.78541429931792},{1.1028480828565677,1.214585700682079},{1.1028480828565677,21.21458570068208},{1.1028480828565677,41.21458570068208},{1.1028480828565677,61.21458570068208},{1.1028480828565677,81.21458570068208},{1.1028480828565677,101.21458570068208},{-18.897151917143432,101.21458570068208},{-38.89715191714344,101.21458570068208},{-38.89715191714344,121.21458570068208},{-58.89715191714344,121.21458570068208}},color={0,0,127}));

  connect(disNet_61afc0e4.port_bDisRet,cooPla_cda7f1b9.port_a)
    annotation (Line(points={{-36.46044064597719,124.82544008235705},{-56.46044064597719,124.82544008235705}},color={0,0,127}));
  connect(cooPla_cda7f1b9.port_b,disNet_61afc0e4.port_aDisSup)
    annotation (Line(points={{-33.43863829577374,121.38657432676455},{-13.438638295773742,121.38657432676455}},color={0,0,127}));
  connect(disNet_61afc0e4.dp,cooPla_cda7f1b9.dpMea)
    annotation (Line(points={{-47.10621744691011,114.25886271975835},{-67.10621744691011,114.25886271975835}},color={0,0,127}));

  //
  // End Connect Statements for 80db10e1
  //



  //
  // Begin Connect Statements for 9ba377dd
  // Source template: /model_connectors/couplings/templates/Network2Pipe_HeatingPlant/ConnectStatements.mopt
  //

  connect(heaPla70ff66d6.port_a,disNet_249a1248.port_bDisRet)
    annotation (Line(points={{-45.56286695768924,80.70539553494316},{-25.562866957689238,80.70539553494316}},color={0,0,127}));
  connect(disNet_249a1248.dp,heaPla70ff66d6.dpMea)
    annotation (Line(points={{-43.77117121356273,71.27071123985259},{-63.77117121356273,71.27071123985259}},color={0,0,127}));
  connect(heaPla70ff66d6.port_b,disNet_249a1248.port_aDisSup)
    annotation (Line(points={{-37.43828732588548,85.91651197220044},{-17.438287325885483,85.91651197220044}},color={0,0,127}));
  connect(mPum_flow_9ba377dd.y,heaPla70ff66d6.on)
    annotation (Line(points={{-63.041716709902964,-27.654514098153044},{-63.041716709902964,-7.654514098153044},{-63.041716709902964,12.345485901846956},{-63.041716709902964,32.345485901846956},{-63.041716709902964,52.345485901846956},{-63.041716709902964,72.34548590184696}},color={0,0,127}));
  connect(TDisSetHeaWat_9ba377dd.y,heaPla70ff66d6.THeaSet)
    annotation (Line(points={{-25.39279060029486,-14.573912034967265},{-25.39279060029486,5.426087965032735},{-25.39279060029486,25.426087965032735},{-25.39279060029486,45.426087965032735},{-25.39279060029486,65.42608796503274},{-45.39279060029486,65.42608796503274},{-45.39279060029486,85.42608796503274},{-65.39279060029486,85.42608796503274}},color={0,0,127}));

  //
  // End Connect Statements for 9ba377dd
  //



  //
  // Begin Connect Statements for f71f3c07
  // Source template: /model_connectors/couplings/templates/TimeSeries_CoolingIndirect/ConnectStatements.mopt
  //

  // cooling indirect, timeseries coupling connections
  connect(TimeSerLoa_166f107f.ports_bChiWat[1], cooInd_4a48b99b.port_a2)
    annotation (Line(points={{44.584457957522176,126.43175849341986},{24.584457957522176,126.43175849341986}},color={0,0,127}));
  connect(cooInd_4a48b99b.port_b2,TimeSerLoa_166f107f.ports_aChiWat[1])
    annotation (Line(points={{33.784517387077045,128.7537895980287},{53.784517387077045,128.7537895980287}},color={0,0,127}));
  connect(pressure_source_f71f3c07.ports[1], cooInd_4a48b99b.port_b2)
    annotation (Line(points={{16.16313472775731,-20.473397087104445},{-3.83686527224269,-20.473397087104445},{-3.83686527224269,-0.47339708710444484},{-3.83686527224269,19.526602912895555},{-3.83686527224269,39.526602912895555},{-3.83686527224269,59.526602912895555},{-3.83686527224269,79.52660291289556},{-3.83686527224269,99.52660291289556},{-3.83686527224269,119.52660291289556},{16.16313472775731,119.52660291289556}},color={0,0,127}));
  connect(TChiWatSet_f71f3c07.y,cooInd_4a48b99b.TSetBuiSup)
    annotation (Line(points={{65.38683688368755,-21.656920734190493},{65.38683688368755,-1.6569207341904928},{65.38683688368755,18.343079265809507},{45.38683688368755,18.343079265809507},{45.38683688368755,38.34307926580951},{45.38683688368755,58.34307926580951},{45.38683688368755,78.34307926580951},{45.38683688368755,98.34307926580951},{45.38683688368755,118.34307926580951},{65.38683688368755,118.34307926580951}},color={0,0,127}));

  //
  // End Connect Statements for f71f3c07
  //



  //
  // Begin Connect Statements for 96e60a9b
  // Source template: /model_connectors/couplings/templates/CoolingIndirect_Network2Pipe/ConnectStatements.mopt
  //

  // cooling indirect and network 2 pipe
  
  connect(disNet_61afc0e4.ports_bCon[1],cooInd_4a48b99b.port_a1)
    annotation (Line(points={{1.320322154335443,115.41754595122775},{21.320322154335443,115.41754595122775}},color={0,0,127}));
  connect(disNet_61afc0e4.ports_aCon[1],cooInd_4a48b99b.port_b1)
    annotation (Line(points={{0.5275581113296965,118.9751548076288},{20.527558111329697,118.9751548076288}},color={0,0,127}));

  //
  // End Connect Statements for 96e60a9b
  //



  //
  // Begin Connect Statements for c31184ec
  // Source template: /model_connectors/couplings/templates/TimeSeries_HeatingIndirect/ConnectStatements.mopt
  //

  // cooling indirect, timeseries coupling connections
  connect(TimeSerLoa_166f107f.ports_bHeaWat[1], heaInd_a5839ad4.port_a2)
    annotation (Line(points={{52.85377634021751,109.63547282551166},{52.85377634021751,89.63547282551166},{32.85377634021752,89.63547282551166},{12.853776340217522,89.63547282551166}},color={0,0,127}));
  connect(heaInd_a5839ad4.port_b2,TimeSerLoa_166f107f.ports_aHeaWat[1])
    annotation (Line(points={{20.19487374033136,106.1831544686746},{40.19487374033136,106.1831544686746},{40.19487374033136,126.1831544686746},{60.19487374033136,126.1831544686746}},color={0,0,127}));
  connect(pressure_source_c31184ec.ports[1], heaInd_a5839ad4.port_b2)
    annotation (Line(points={{-63.03877379917057,-54.93217620276903},{-43.03877379917057,-54.93217620276903},{-43.03877379917057,-34.93217620276903},{-43.03877379917057,-14.932176202769028},{-43.03877379917057,5.067823797230972},{-43.03877379917057,25.067823797230957},{-43.03877379917057,45.06782379723096},{-43.03877379917057,65.06782379723096},{-23.03877379917057,65.06782379723096},{-3.0387737991705706,65.06782379723096},{-3.0387737991705706,85.06782379723096},{16.96122620082943,85.06782379723096}},color={0,0,127}));
  connect(THeaWatSet_c31184ec.y,heaInd_a5839ad4.TSetBuiSup)
    annotation (Line(points={{-25.59490466566112,-52.80179868456207},{-5.594904665661119,-52.80179868456207},{-5.594904665661119,-32.80179868456207},{-5.594904665661119,-12.801798684562073},{-5.594904665661119,7.198201315437927},{-5.594904665661119,27.198201315437913},{-5.594904665661119,47.19820131543791},{-5.594904665661119,67.19820131543791},{-5.594904665661119,87.19820131543793},{14.405095334338881,87.19820131543793}},color={0,0,127}));

  //
  // End Connect Statements for c31184ec
  //



  //
  // Begin Connect Statements for e2e23d71
  // Source template: /model_connectors/couplings/templates/HeatingIndirect_Network2Pipe/ConnectStatements.mopt
  //

  // heating indirect and network 2 pipe
  
  connect(disNet_249a1248.ports_bCon[1],heaInd_a5839ad4.port_a1)
    annotation (Line(points={{-9.360006917021082,89.54455775875391},{10.639993082978918,89.54455775875391}},color={0,0,127}));
  connect(disNet_249a1248.ports_aCon[1],heaInd_a5839ad4.port_b1)
    annotation (Line(points={{9.248494741636023,77.21224464273429},{29.248494741636023,77.21224464273429}},color={0,0,127}));

  //
  // End Connect Statements for e2e23d71
  //



  //
  // Begin Connect Statements for 0650fc70
  // Source template: /model_connectors/couplings/templates/Teaser_CoolingIndirect/ConnectStatements.mopt
  //

  connect(TeaserLoad_e7825bcc.ports_bChiWat[1], cooInd_0844b396.port_a2)
    annotation (Line(points={{31.928558738180172,33.80245721950044},{11.928558738180172,33.80245721950044}},color={0,0,127}));
  connect(cooInd_0844b396.port_b2,TeaserLoad_e7825bcc.ports_aChiWat[1])
    annotation (Line(points={{43.029358819287154,37.76470132336671},{63.029358819287154,37.76470132336671}},color={0,0,127}));
  connect(pressure_source_0650fc70.ports[1], cooInd_0844b396.port_b2)
    annotation (Line(points={{12.33790658990928,-60.90980469404889},{-7.662093410090719,-60.90980469404889},{-7.662093410090719,-40.90980469404889},{-7.662093410090719,-20.909804694048887},{-7.662093410090719,-0.9098046940488871},{-7.662093410090719,19.090195305951113},{-7.662093410090719,39.09019530595111},{12.33790658990928,39.09019530595111}},color={0,0,127}));
  connect(TChiWatSet_0650fc70.y,cooInd_0844b396.TSetBuiSup)
    annotation (Line(points={{62.67888500937411,-64.61046692446467},{42.67888500937411,-64.61046692446467},{42.67888500937411,-44.610466924464674},{42.67888500937411,-24.610466924464674},{42.67888500937411,-4.610466924464674},{42.67888500937411,15.389533075535326},{42.67888500937411,35.38953307553534},{62.67888500937411,35.38953307553534}},color={0,0,127}));

  //
  // End Connect Statements for 0650fc70
  //



  //
  // Begin Connect Statements for 58ff9e9b
  // Source template: /model_connectors/couplings/templates/CoolingIndirect_Network2Pipe/ConnectStatements.mopt
  //

  // cooling indirect and network 2 pipe
  
  connect(disNet_61afc0e4.ports_bCon[2],cooInd_0844b396.port_a1)
    annotation (Line(points={{-21.884270688732187,96.19546631519472},{-1.8842706887321867,96.19546631519472},{-1.8842706887321867,76.19546631519472},{-1.8842706887321867,56.19546631519472},{-1.8842706887321867,36.19546631519472},{18.115729311267813,36.19546631519472}},color={0,0,127}));
  connect(disNet_61afc0e4.ports_aCon[2],cooInd_0844b396.port_b1)
    annotation (Line(points={{-23.886858763325293,97.52962202451596},{-3.886858763325293,97.52962202451596},{-3.886858763325293,77.52962202451596},{-3.886858763325293,57.52962202451596},{-3.886858763325293,37.52962202451596},{16.113141236674707,37.52962202451596}},color={0,0,127}));

  //
  // End Connect Statements for 58ff9e9b
  //



  //
  // Begin Connect Statements for cc6ef5c7
  // Source template: /model_connectors/couplings/templates/Teaser_HeatingIndirect/ConnectStatements.mopt
  //

  connect(TeaserLoad_e7825bcc.ports_bHeaWat[1], heaInd_e75dd196.port_a2)
    annotation (Line(points={{64.85015647550023,29.08068087099663},{64.85015647550023,9.080680870996616},{44.85015647550023,9.080680870996616},{24.850156475500242,9.080680870996616}},color={0,0,127}));
  connect(heaInd_e75dd196.port_b2,TeaserLoad_e7825bcc.ports_aHeaWat[1])
    annotation (Line(points={{11.17479571973169,27.56741885388483},{31.17479571973169,27.56741885388483},{31.17479571973169,47.56741885388483},{51.17479571973169,47.56741885388483}},color={0,0,127}));
  connect(pressure_source_cc6ef5c7.ports[1], heaInd_e75dd196.port_b2)
    annotation (Line(points={{-53.31131122121711,-108.66693613874293},{-33.31131122121711,-108.66693613874293},{-33.31131122121711,-88.66693613874293},{-33.31131122121711,-68.66693613874293},{-33.31131122121711,-48.666936138742926},{-33.31131122121711,-28.666936138742926},{-33.31131122121711,-8.666936138742926},{-13.31131122121711,-8.666936138742926},{6.68868877878289,-8.666936138742926},{26.68868877878289,-8.666936138742926}},color={0,0,127}));
  connect(THeaWatSet_cc6ef5c7.y,heaInd_e75dd196.TSetBuiSup)
    annotation (Line(points={{-13.382724319092759,-103.00781831600989},{6.617275680907241,-103.00781831600989},{6.617275680907241,-83.00781831600989},{6.617275680907241,-63.00781831600989},{6.617275680907241,-43.00781831600989},{6.617275680907241,-23.00781831600989},{6.617275680907241,-3.007818316009889},{26.61727568090724,-3.007818316009889}},color={0,0,127}));

  //
  // End Connect Statements for cc6ef5c7
  //



  //
  // Begin Connect Statements for c3623bb1
  // Source template: /model_connectors/couplings/templates/HeatingIndirect_Network2Pipe/ConnectStatements.mopt
  //

  // heating indirect and network 2 pipe
  
  connect(disNet_249a1248.ports_bCon[2],heaInd_e75dd196.port_a1)
    annotation (Line(points={{-16.573756399261754,57.70437288796052},{-16.573756399261754,37.70437288796052},{-16.573756399261754,17.704372887960517},{-16.573756399261754,-2.295627112039483},{3.426243600738246,-2.295627112039483},{23.426243600738246,-2.295627112039483}},color={0,0,127}));
  connect(disNet_249a1248.ports_aCon[2],heaInd_e75dd196.port_b1)
    annotation (Line(points={{-25.75351596966661,64.83469144196755},{-25.75351596966661,44.83469144196755},{-25.75351596966661,24.83469144196755},{-25.75351596966661,4.83469144196755},{-5.7535159696666085,4.83469144196755},{14.246484030333392,4.83469144196755}},color={0,0,127}));

  //
  // End Connect Statements for c3623bb1
  //




annotation(
  experiment(
    StopTime=86400,
    Interval=3600,
    Tolerance=1e-06),
  Diagram(
    coordinateSystem(
      preserveAspectRatio=false,
      extent={{-90.0,-150.0},{90.0,150.0}})),
  Documentation(
    revisions="<html>
 <li>
 May 10, 2020: Hagar Elarga<br/>
Updated implementation to handle template needed for GeoJSON to Modelica.
</li>
</html>"));
end DistrictEnergySystem;