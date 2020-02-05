with Ada.Numerics.Discrete_Random; use Ada.Numerics;

package body Substances is
   subtype Low_Range is Positive range 40 .. 79;
   subtype Medium_Range is Positive range 80 .. 120;
   subtype High_Range is Positive range 121 .. 160;
   package Random_Low_Weights is new Discrete_Random(Low_Range);
   package Random_Medium_Weights is new Discrete_Random(Medium_Range);
   package Random_High_Weights is new Discrete_Random(High_Range);
   use Random_Low_Weights;
   use Random_Medium_Weights;
   use Random_High_Weights;
   Low_Gen: Random_Low_Weights.Generator;
   Med_Gen: Random_Medium_Weights.Generator;
   High_Gen: Random_High_Weights.Generator;
   Substances: array (Substance_Names) of Substance;

   function Get_Name (Drug: in Substance_Names) return Unbounded_String is
   begin
      return Substances (Drug).Name;
   end Get_Name;

   function Get_Risk (Drug: in Substance_Names) return Percent is
   begin
      return Substances(Drug).Risk;
   end Get_Risk;

   procedure Set_Risk (Drug: in Substance_Names; New_Val: Percent) is
   begin
      Substances(Drug).Risk := New_Val;
   end Set_Risk;

   function Get_Demand (Drug: in Substance_Names) return Level is
   begin
      return Substances(Drug).Demand;
   end Get_Demand;

   procedure Set_Demand (Drug: in Substance_Names; New_Val: Level) is
   begin
      Substances(Drug).Demand := New_Val;
   end Set_Demand;

   function Get_Supply (Drug: in Substance_Names) return Level is
   begin
      return Substances(Drug).Supply;
   end Get_Supply;

   procedure Set_Supply (Drug: in Substance_Names; New_Val: Level) is
   begin
      Substances(Drug).Supply := New_Val;
   end Set_Supply;

   function Get_Market_Rate (Drug: in Substance_Names) return Positive is
      function Get_Random_Weight(Weight_Level: in Level) return Positive is
         Weight: Positive;
      begin
         case (Weight_Level) is
            when Low =>
               Weight := Random(Low_Gen);
            when Medium =>
               Weight := Random(Med_Gen);
            when High =>
               Weight := Random(High_Gen);
         end case;
         return Weight;
      end Get_Random_Weight;

      Demand_Weight: Positive := Get_Random_Weight(Substances(Drug).Demand);
      Supply_Weight: Positive := Get_Random_Weight(Substances(Drug).Supply);
   begin
      return Substances(Drug).Base_Price * Demand_Weight * Supply_Weight / 10_000;
   end Get_Market_Rate;
begin
   Reset(Low_Gen);
   Reset(Med_Gen);
   Reset(High_Gen);
   Substances := (
                  (Name => To_Unbounded_String("Cocaine"),
                   Base_Price => 35,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Heroin"),
                   Base_Price => 40,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Molly"),
                   Base_Price =>  25,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Marijuana"),
                   Base_Price => 15,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Jenkem"),
                   Base_Price => 10,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Crystal Meth"),
                   Base_Price => 20,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Ketamine"),
                   Base_Price => 15,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("LSD"),
                   Base_Price => 25,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Shrooms"),
                   Base_Price => 20,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Adderall"),
                   Base_Price => 10,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("Vicodin"),
                   Base_Price => 10,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium),
                  (Name => To_Unbounded_String("PCP"),
                   Base_Price => 25,
                   Risk => 0,
                   Demand => Medium,
                   Supply => Medium)
                 );
end Substances;
