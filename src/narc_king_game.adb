with Ada.Numerics.Discrete_Random; use Ada.Numerics;
package body Narc_King_Game is
   --INTERNAL TYPES AND DATA -------------------------------------------------------------
   subtype Percent is Natural range 0..100;
   type Level is (Low, Medium, High);
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

   type Substance_Entry is
      record
         Name: Unbounded_String;
         Base_Price: Positive;
         Market_Price: Positive;
         Risk: Percent;
         Demand: Level;
         Supply: Level;
         Quantity: Natural;
         Available: Boolean;
      end record;
   Market_Substances: array (Substance) of Substance_Entry;

   Player_Substances: array (Substance) of Natural range 0 .. 100;
   Player_Tools: array (Tool) of Boolean;
   Player_Debt: Natural;
   Player_Balance: Natural;

   --INTERNAL HELPER FUNCTIONS------------------------------------------------------------

   function Calculate_Market_Rate (Drug: in Substance) return Positive is
      --Determine the market rate for a drug based on its specified supply & demand levels
      function Get_Random_Supply_Weight(Weight_Level: in Level) return Positive is
         Weight: Positive;
      begin
         case (Weight_Level) is
            when Low => Weight := Random(High_Gen);
            when Medium => Weight := Random(Med_Gen);
            when High => Weight := Random(Low_Gen);
         end case;
         return Weight;
      end Get_Random_Supply_Weight;

      function Get_Random_Demand_Weight(Weight_Level: in Level) return Positive is
         Weight: Positive;
      begin
         case (Weight_Level) is
            when Low => Weight := Random(Low_Gen);
            when Medium => Weight := Random(Med_Gen);
            when High => Weight := Random(High_Gen);
         end case;
         return Weight;
      end Get_Random_Demand_Weight;

      Demand_Weight: Positive := Get_Random_Demand_Weight(Market_Substances(Drug).Demand);
      Supply_Weight: Positive := Get_Random_Supply_Weight(Market_Substances(Drug).Supply);
   begin
      return Market_Substances(Drug).Base_Price * Demand_Weight * Supply_Weight / 10_000;
   end Calculate_Market_Rate;

   --PUBLICLY VISIBLE FUNCTIONS-----------------------------------------------------------

   procedure Start_Game is
   begin
      Reset(Low_Gen);
      Reset(Med_Gen);
      Reset(High_Gen);
      Player_Substances := (others => 0);
      Player_Tools := (others => False);
      Player_Debt := 500;
      Player_Balance := 500;
      Market_Substances := (
                     (Name => To_Unbounded_String("Cocaine"),
                      Base_Price => 35,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Heroin"),
                      Base_Price => 40,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Molly"),
                      Base_Price =>  25,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Marijuana"),
                      Base_Price => 15,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Jenkem"),
                      Base_Price => 10,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Crystal Meth"),
                      Base_Price => 20,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Ketamine"),
                      Base_Price => 15,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("LSD"),
                      Base_Price => 25,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Shrooms"),
                      Base_Price => 20,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Adderall"),
                      Base_Price => 10,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("Vicodin"),
                      Base_Price => 10,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium),
                     (Name => To_Unbounded_String("PCP"),
                      Base_Price => 25,
                      Market_Price => 1,
                      Risk => 0,
                      Quantity => 25,
                      Available => False,
                      others => Medium)
                    );
   end Start_Game;

   function Change_City return Available_Drugs is
      Drug_Options: Available_Drugs := (others => False);
   begin
      for I in Substance loop
         --TODO: Create a random generator for determining which drugs will be available
         if Market_Substances(I).Available = True then
            Market_Substances(I).Market_Price := Calculate_Market_Rate(I);
         end if;
      end loop;
      return Drug_Options;
   end Change_City;

   procedure Buy_Drug (Drug: in Substance;
                       Purchase_Quantity: in Positive;
                       Remaining_In_Market: out Natural;
                       Inventory_Quantity: out Positive;
                       Fight_Triggered: out Boolean) is
      Old_Market_Amount: Natural := Market_Substances(Drug).Quantity;
      Old_Player_Amount: Natural := Player_Substances(Drug);
      Old_Player_Balance: Natural := Player_Balance;
   begin
      Player_Balance := Player_Balance - Market_Substances(Drug).Market_Price;
      Market_Substances(Drug).Quantity := Market_Substances(Drug).Quantity - Purchase_Quantity;
      Player_Substances(Drug) := Player_Substances(Drug) + Purchase_Quantity *
        Market_Substances(Drug).Market_Price;
      Remaining_In_Market := Market_Substances(Drug).Quantity;
      Inventory_Quantity := Player_Substances(Drug);
      --TODO: Add logic to determine whether a fight was triggered.
   exception
      when Constraint_Error =>
         Market_Substances(Drug).Quantity := Old_Market_Amount;
         Player_Substances(Drug) := Old_Player_Amount;
         Player_Balance := Old_Player_Balance;
         raise;
   end Buy_Drug;

   procedure Sell_Drug (Drug: in Substance;
                        Sell_Quantity: in Positive;
                        Remaining_In_Market: out Positive;
                        Inventory_Quantity: out Natural;
                        Fight_Triggered: out Boolean) is
   begin
      Market_Substances(Drug).Quantity := Market_Substances(Drug).Quantity - Sell_Quantity;
      Player_Substances(Drug) := Player_Substances(Drug) + Sell_Quantity;
      Remaining_In_Market := Market_Substances(Drug).Quantity;
      Inventory_Quantity := Player_Substances(Drug);
      --TODO: Add logic to determine whether a fight was triggered.
   end Sell_Drug;

   function Select_Fight_Choice (Choice: in Fight_Choice)
                                 return Fight_Outcome is
      Outcome: Fight_Outcome;
   begin
      return Outcome; --TODO: Add logic to determine result of fight choice
   end Select_Fight_Choice;

   procedure Buy_Tool (Tool_To_Buy: in Tool) is
   begin
      null;
   end Buy_Tool;

   function Get_Loan (Loan_Size: in Positive) return Positive is
   begin
      Player_Debt := Player_Debt + Loan_Size;
      return Player_Debt;
   end Get_Loan;

   function Make_Loan_Payment (Payment_Amount: in Positive) return Natural is
   begin
      Player_Debt := Player_Debt - Payment_Amount;
      return Player_Debt;
   end Make_Loan_Payment;

   function Get_Name (Drug: in Substance) return Unbounded_String is
   begin
      return Market_Substances(Drug).Name;
   end Get_Name;

   function Get_Market_Count (Drug: in Substance) return Natural is
   begin
      return Market_Substances(Drug).Quantity;
   end Get_Market_Count;

   function Get_Market_Rate (Drug: in Substance) return Positive is
   begin
      return Market_Substances(Drug).Market_Price;
   end Get_Market_Rate;

   function Get_Inventory_Quantity (Drug: in Substance) return Natural is
   begin
      return Player_Substances(Drug);
   end Get_Inventory_Quantity;

   function Player_Has_Tool (Tool_Name: in Tool) return Boolean is
   begin
      return Player_Tools(Tool_Name);
   end Player_Has_Tool;

   function Get_Player_Balance return Natural is
   begin
      return Player_Balance;
   end Get_Player_Balance;

   function Get_Player_Debt return Natural is
   begin
      return Player_Debt;
   end Get_Player_Debt;
end Narc_King_Game;
