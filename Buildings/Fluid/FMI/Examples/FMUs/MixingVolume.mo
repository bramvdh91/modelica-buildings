within Buildings.Fluid.FMI.Examples.FMUs;
block MixingVolume "Container to export a control volume as an FMU"
  extends TwoPort(redeclare package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated);

  parameter Modelica.SIunits.Volume V=1 "Volume";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.1
    "Nominal mass flow rate";

protected
  Inlet bouIn(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal) "Boundary model for inlet"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Outlet bouOut(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal) "Boundary component for outlet"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final V=V,
    nPorts=2) "Control volume"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
equation
  connect(inlet, bouIn.inlet) annotation (Line(
      points={{-110,0},{-81,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouOut.outlet, outlet) annotation (Line(
      points={{81,0},{110,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouIn.p, bouOut.p) annotation (Line(
      points={{-70,-11},{-70,-20},{70,-20},{70,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouIn.port_b, vol.ports[1]) annotation (Line(
      points={{-60,0},{-2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], bouOut.port_a) annotation (Line(
      points={{2,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="vol",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a
control volume.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/MixingVolume.mos"
        "Export FMU"),
    Icon(graphics={
        Rectangle(
          extent={{-100,14},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
                              Ellipse(
          extent={{-26,30},{40,-36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255})}));
end MixingVolume;