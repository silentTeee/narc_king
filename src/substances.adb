package body Substances is
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

   function Get_Demand (Drug: in Substance_Names) return Demand is
   begin
      return Substances(Drug).Popularity;
   end Get_Demand;

   procedure Set_Demand (Drug: in Substance_Names; New_Val: Demand) is
   begin
      Substances(Drug).Popularity := New_Val;
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
      Market_Cost: Positive;
   begin
      Market_Cost := Substances(Drug).Base_Price * ;
   end Get_Market_Rate;
begin
   Substances := (
                  (Name => To_Unbounded_String("Cocaine"),
                   Base_Price => 35),
                  (Name => To_Unbounded_String("Heroin"),
                   Base_Price => 40),
                  (Name => To_Unbounded_String("Molly"),
                   Base_Price =>  25),
                  (Name => To_Unbounded_String("Marijuana"),
                   Base_Price => 15),
                  (Name => To_Unbounded_String("Jenkem"),
                   Base_Price => 10),
                  (Name => To_Unbounded_String("Crystal Meth"),
                   Base_Price => 20),
                  (Name => To_Unbounded_String("Ketamine"),
                   Base_Price => 15),
                  (Name => To_Unbounded_String("LSD"),
                   Base_Price => 25),
                  (Name => To_Unbounded_String("Shrooms"),
                   Base_Price => 20),
                  (Name => To_Unbounded_String("Adderall"),
                   Base_Price => 10),
                  (Name => To_Unbounded_String("Vicodin"),
                   Base_Price => 10),
                  (Name => To_Unbounded_String("PCP"),
                   Base_Price => 25)
                 );
end Substances;
