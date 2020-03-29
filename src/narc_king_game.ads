with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package Narc_King_Game is
   --GAME FLOW FUNCTIONS-------------------------------------------------------------------
   type Fight_Choice is (Run, Fight);
   type Fight_Outcome is (Died, Won, Escaped);
   type Substance is (Cocaine, Heroin, Molly, Marijuana, Jenkem, Crystal_Meth,
                      Ketamine, LSD, Shrooms, Adderall, Vicodin, PCP);
   type Tool is (Bullet_Magazine, Bulletproof_Vest);
   type Available_Drugs is array (Substance) of Boolean;

   procedure Start_Game;
   --This initiates the game

   function Change_City return Available_Drugs;
   --Changes the city you're in, and randomly selects the drugs that are available,
   --The amounts that are available, their price, etc.

   procedure Buy_Drug (Drug: in Substance;
                       Purchase_Quantity: in Positive;
                       Remaining_In_Market: out Natural;
                       Inventory_Quantity: out Positive;
                       Fight_Triggered: out Boolean);
   --Purchases a drug and stores it in the player inventory. Indicates how much is left
   --in the market, as well as whether a fight event was triggered from the transaction.

   procedure Sell_Drug (Drug: in Substance;
                        Sell_Quantity: in Positive;
                        Remaining_In_Market: out Positive;
                        Inventory_Quantity: out Natural;
                        Fight_Triggered: out Boolean);
   --Sells a drug and removes it from the player inventory. Indicates how much is left
   --in the market, as well as whether a fight event was triggered from the transaction.

   function Select_Fight_Choice (Choice: in Fight_Choice)
                                 return Fight_Outcome;
   --If a fight event is triggered, the player has to decide whether they fight or run
   --away. The return value indicates whether they succeeded in the fight, escaped or died.

   procedure Buy_Tool (Tool_To_Buy: in Tool);
   --Purchase a tool that improves the player's chances in a fight.
   --TODO: create a "black market" for buying tools and getting/paying off loans.

   function Get_Loan (Loan_Size: in Positive) return Positive;
   --Allow the player to get a loan, returns the new loan remainder

   function Make_Loan_Payment (Payment_Amount: in Positive) return Natural;
   --Make a payment toward the player's loan, returns new loan remainder.

   --STATE RETRIEVAL FUNCTIONS------------------------------------------------------------

   function Get_Name (Drug: in Substance) return Unbounded_String;
   --Get a drug's name as an unbounded string.

   function Get_Market_Count (Drug: in Substance) return Natural;
   --Get the number of doses of a drug available in the market.

   function Get_Market_Rate (Drug: in Substance) return Positive;
   --Get the going market rate for a specific drug.

   function Get_Inventory_Quantity (Drug: in Substance) return Natural;
   --Get the number of doses of the specified drug in the player's inventory.

   function Player_Has_Tool (Tool_Name: in Tool) return Boolean;
   --Check whether the player owns the specified tool (they can only have one of each).

   function Get_Player_Balance return Natural;
   --Check the player's current financial balance.

   function Get_Player_Debt return Natural;
   --Check the player's current loan amount.

end Narc_King_Game;
