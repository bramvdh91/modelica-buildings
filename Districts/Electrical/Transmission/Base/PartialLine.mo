within Districts.Electrical.Transmission.Base;
partial model PartialLine "Cable line dispersion model"
  extends Districts.Electrical.Interfaces.PartialTwoPort;
  parameter Modelica.SIunits.Distance Length(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal "Nominal voltage of the line";

  parameter Boolean useExtTemp = false
    "If =true, enables the input for the temperature of the cable" annotation(Dialog(tab="Model"));
  parameter Modelica.SIunits.Temperature Tcable = T_ref
    "Fixed temperature of the cable" annotation(Dialog(tab="Model", enable = not useExtTemp));
  parameter Districts.Electrical.Types.CableMode mode = Districts.Electrical.Types.CableMode.automatic
    "If =true the size of the cable is defined as a continuous variable" annotation(Dialog(tab="Tech. specification"), choicesAllMatching=true);
  parameter Districts.Electrical.Transmission.CommercialCables.Cable commercialCable = Districts.Electrical.Transmission.CommercialCables.Cable(RCha=0, XCha=0, In=0)
    "List of various commercial cables" annotation(Dialog(tab="Tech. specification", enable = mode == Districts.Electrical.Types.CableMode.commercial),  choicesAllMatching = true);
  parameter Districts.Electrical.Transmission.Cables.Cable cable=
      Functions.selectCable(P_nominal, V_nominal, mode == Districts.Electrical.Types.CableMode.automatic)
    "Type of cable"
  annotation (choicesAllMatching=true,Dialog(tab="Tech. specification", enable = mode==Districts.Electrical.Types.CableMode.normative), Placement(transformation(extent={{20,60},
            {40,80}})));
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Functions.selectMaterial(0.0) "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification", enable=mode==Districts.Electrical.Types.CableMode.normative), Placement(transformation(extent={{60,60},
            {80,80}})));
  final parameter Modelica.SIunits.Temperature T_ref=wireMaterial.T0
    "Reference temperature of the line" annotation(Evaluate=True);
  final parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=wireMaterial.alphaT0
    "Linear temperature coefficient of the material"                                                                                         annotation(Evaluate=True);
  final parameter Modelica.SIunits.Resistance R = Districts.Electrical.Transmission.Functions.lineResistance(Length, cable, wireMaterial, commercialCable, mode)
    "Resistance of the cable" annotation(Evaluate=True);
  final parameter Modelica.SIunits.Inductance L = Districts.Electrical.Transmission.Functions.lineInductance(Length, cable, commercialCable, mode)
    "Inductance of the cable due to mutual and self inductance" annotation(Evaluate = True);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature cableTemp
    "Temperature of the cable"
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Modelica.Blocks.Interfaces.RealInput T if useExtTemp
    "Temperature of the cable"                                                    annotation (
     Placement(transformation(extent={{-42,28},{-2,68}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
protected
  Modelica.Blocks.Interfaces.RealInput T_in;
public
  Modelica.Blocks.Sources.RealExpression cableTemperature(y=T_in)
    annotation (Placement(transformation(extent={{-92,12},{-72,32}})));
equation
  assert(L>=0, "The inductance of the cable is negative, check cable properties and size");
  connect(T_in, T);

  if not useExtTemp then
    T_in = Tcable;
  end if;

  connect(cableTemperature.y, cableTemp.T) annotation (Line(
      points={{-71,22},{-62,22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{14,40},{40,16}},
          lineColor=DynamicSelect({0,0,255}, if useExtTemp then {0,0,255} else {255,255,
              255}),
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T")}));
end PartialLine;
