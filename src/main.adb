with Ada.Text_IO; use Ada.Text_IO;
with Substances; use Substances;
procedure Main is
begin
   Put_Line("Market Rate for Cocaine: " & Integer'Image(Get_Market_Rate(Cocaine)));
   null;
end Main;
