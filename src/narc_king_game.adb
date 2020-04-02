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
   package Random_Substances is new Discrete_Random(Substance);
   package Rand_Int is new Discrete_Random(Integer);
   use Rand_Int;
   use Random_Substances;
   use Random_Low_Weights;
   use Random_Medium_Weights;
   use Random_High_Weights;
   Low_Gen: Random_Low_Weights.Generator;
   Med_Gen: Random_Medium_Weights.Generator;
   High_Gen: Random_High_Weights.Generator;
   Drug_Gen: Random_Substances.Generator;
   Int_Gen: Rand_Int.Generator;

   type Game_State is (Not_In_Game, Game_Started, Free_Roam, In_Fight);
   Current_Game_State: Game_State := Not_In_Game;
   Wrong_Call_State_Exception: exception;

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

   function Calculate_Market_Rate (Drug: in Substance;
                                   Supply_Level: in Level;
                                   Demand_Level: in Level) return Positive is
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

      Demand_Weight: Positive := Get_Random_Demand_Weight(Demand_Level);
      Supply_Weight: Positive := Get_Random_Supply_Weight(Supply_Level);
   begin
      return Market_Substances(Drug).Base_Price * Demand_Weight * Supply_Weight / 10_000;
   end Calculate_Market_Rate;

   --PUBLICLY VISIBLE FUNCTIONS-----------------------------------------------------------

   procedure Start_Game is
   begin
      case Current_Game_State is
         when Not_In_Game =>
            Reset(Low_Gen);
            Reset(Med_Gen);
            Reset(High_Gen);
            Reset(Drug_Gen);
            Reset(Int_Gen);
            Player_Substances := (others => 0);
            Player_Tools := (others => False);
            Player_Debt := 500;
            Player_Balance := 500;
            Market_Substances := (Cocaine =>
                                    (Name => To_Unbounded_String("Cocaine"),
                                     Base_Price => 35,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Heroin =>
                                    (Name => To_Unbounded_String("Heroin"),
                                     Base_Price => 40,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Molly =>
                                    (Name => To_Unbounded_String("Molly"),
                                     Base_Price =>  25,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Marijuana =>
                                    (Name => To_Unbounded_String("Marijuana"),
                                     Base_Price => 15,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Jenkem =>
                                    (Name => To_Unbounded_String("Jenkem"),
                                     Base_Price => 10,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Crystal_Meth =>
                                    (Name => To_Unbounded_String("Crystal Meth"),
                                     Base_Price => 20,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Ketamine =>
                                    (Name => To_Unbounded_String("Ketamine"),
                                     Base_Price => 15,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  LSD =>
                                    (Name => To_Unbounded_String("LSD"),
                                     Base_Price => 25,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Shrooms =>
                                    (Name => To_Unbounded_String("Shrooms"),
                                     Base_Price => 20,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Adderall =>
                                    (Name => To_Unbounded_String("Adderall"),
                                     Base_Price => 10,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  Vicodin =>
                                    (Name => To_Unbounded_String("Vicodin"),
                                     Base_Price => 10,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium),
                                  PCP =>
                                    (Name => To_Unbounded_String("PCP"),
                                     Base_Price => 25,
                                     Market_Price => 1,
                                     Risk => 0,
                                     Quantity => 25,
                                     Available => False,
                                     others => Medium));
            Current_Game_State := Game_Started;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
   end Start_Game;

   procedure Change_City(Drug_Options: out Available_Drugs) is
      New_Idx: Integer;
      Temp_Drug: Substance;
      Drug_List: array (Natural range Substance'Pos(Substance'First)..
                          Substance'Pos(Substance'Last)) of Substance;
   begin
      case Current_Game_State is
         when Game_Started | Free_Roam =>
            --create a random shuffle of the substances
            for I in Drug_List'Range loop
               Drug_List(I) := Substance'Val(I);
            end loop;
            for Old_Idx in reverse Drug_List'Range loop
               New_Idx := (Random(Int_Gen) mod Old_Idx);
               Temp_Drug := Drug_List(Old_Idx);
               Drug_List(Old_Idx) := Drug_List(New_Idx);
               Drug_List(New_Idx) := Temp_Drug;
            end loop;
            --Pick 4 of the substances to be made available in the new city, and update their
            --stats
            for I in Drug_List'Range loop
               if I < Drug_List'First + 4 then
                  Drug_Options(Drug_List(I)) := True;
                  Market_Substances(Drug_List(I)).Available := Drug_Options(Drug_List(I));
                  Market_Substances(Drug_List(I)).Market_Price :=
                    Calculate_Market_Rate(Drug_List(I),
                                          Market_Substances(Drug_List(I)).Supply,
                                          Market_Substances(Drug_List(I)).Demand);
                  --TODO: incorporate supply, demand, and risk calculation!
               else
                  Drug_Options(Drug_List(I)) := False;
                  Market_Substances(Drug_List(I)).Available := Drug_Options(Drug_List(I));
                  Market_Substances(Drug_List(I)).Market_Price := 1;
               end if;
            end loop;
            if Current_Game_State = Game_Started then
               Current_Game_State := Free_Roam;
            end if;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
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
      case Current_Game_State is
         when Free_Roam =>
            Player_Balance := Player_Balance - Purchase_Quantity *
              Market_Substances(Drug).Market_Price;
            Market_Substances(Drug).Quantity := Market_Substances(Drug).Quantity -
              Purchase_Quantity;
            Player_Substances(Drug) := Player_Substances(Drug) + Purchase_Quantity;
            Remaining_In_Market := Market_Substances(Drug).Quantity;
            Inventory_Quantity := Player_Substances(Drug);
            --Determine whether a fight was triggered and the appropriate state transition
            if Random(Int_Gen) mod 101 < Market_Substances(Drug).Risk then
               Current_Game_State := In_Fight;
               Fight_Triggered := True;
            else
               Current_Game_State := Free_Roam;
               Fight_Triggered := False;
            end if;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
   exception
      when others =>
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
      Old_Market_Amount: Natural := Market_Substances(Drug).Quantity;
      Old_Player_Amount: Natural := Player_Substances(Drug);
      Old_Player_Balance: Natural := Player_Balance;
   begin
      case Current_Game_State is
         when Free_Roam =>
            Player_Balance := Player_Balance + Sell_Quantity *
              Market_Substances(Drug).Market_Price;
            Market_Substances(Drug).Quantity := Market_Substances(Drug).Quantity +
              Sell_Quantity;
            Player_Substances(Drug) := Player_Substances(Drug) - Sell_Quantity;
            Remaining_In_Market := Market_Substances(Drug).Quantity;
            Inventory_Quantity := Player_Substances(Drug);
            --Determine whether a fight was triggered and the appropriate state transition
            if Random(Int_Gen) mod 101 < Market_Substances(Drug).Risk then
               Current_Game_State := In_Fight;
               Fight_Triggered := True;
            else
               Current_Game_State := Free_Roam;
               Fight_Triggered := False;
            end if;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
   exception
      when others =>
         Market_Substances(Drug).Quantity := Old_Market_Amount;
         Player_Substances(Drug) := Old_Player_Amount;
         Player_Balance := Old_Player_Balance;
         raise;
   end Sell_Drug;

   function Select_Fight_Choice (Choice: in Fight_Choice)
                                 return Fight_Outcome is
      Death_Chance: Natural;
      Outcome: Fight_Outcome;
   begin
      case Current_Game_State is
         when In_Fight =>
            case Choice is
            when Run =>
               case Player_Tools(Bulletproof_Vest) is
               when True => Death_Chance := 25;
               when False => Death_Chance := 50;
               end case;
               if Random(Int_Gen) mod 101 < Death_Chance then
                  Outcome := Died;
               else
                  Outcome := Escaped;
               end if;
            when Fight =>
               case Player_Tools(Bullet_Magazine) is
               when True => Death_Chance := 25;
               when False => Death_Chance := 50;
               end case;
               if Random(Int_Gen) mod 101 < Death_Chance then
                  Outcome := Died;
               else
                  Outcome := Won;
               end if;
            end case;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
      return Outcome;
   end Select_Fight_Choice;

   procedure Buy_Tool (Tool_To_Buy: in Tool) is
      Tool_Cost: Positive := 500;
      Old_Player_Tools: Boolean := Player_Tools(Tool_To_Buy);
      Old_Player_Balance: Natural := Player_Balance;
   begin
      case Current_Game_State is
         when Free_Roam =>
            case (Player_Tools(Tool_To_Buy)) is
            when False =>
               Player_Tools(Tool_To_Buy) := True;
               Player_Balance := Player_Balance - Tool_Cost;
            when True =>
               raise Constraint_Error;
            end case;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
   exception
      when others =>
         Player_Tools(Tool_To_Buy) := Old_Player_Tools;
         Player_Balance := Old_Player_Balance;
   end Buy_Tool;

   function Get_Loan (Loan_Size: in Positive) return Positive is
      Old_Debt: Natural := Player_Debt;
   begin
      case Current_Game_State is
         when Free_Roam =>
            Player_Debt := Player_Debt + Loan_Size;
            return Player_Debt;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
   exception
      when others =>
         Player_Debt := Old_Debt;
         raise;
   end Get_Loan;

   function Make_Loan_Payment (Payment_Amount: in Positive) return Natural is
      Old_Debt: Natural := Player_Debt;
   begin
      case Current_Game_State is
         when Free_Roam =>
            Player_Debt := Player_Debt - Payment_Amount;
            return Player_Debt;
         when others =>
            raise Wrong_Call_State_Exception;
      end case;
   exception
      when others =>
         Player_Debt := Old_Debt;
         raise;
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
