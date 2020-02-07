with Ada.Text_IO; use Ada.Text_IO;
with Drug_Market; use Drug_Market;
procedure Main is
begin
   Put_Line("Market Rate for Cocaine: " & Integer'Image(Get_Market_Rate(Cocaine)));
end Main;
