with Substances; use Substances;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Drug_Market is
   subtype Percent is Natural range 0..100;
   type Level is (Low, Medium, High);

   function Get_Name (Drug: in Substance_Names) return Unbounded_String;

   function Get_Risk (Drug: in Substance_Names) return Percent;
   procedure Set_Risk (Drug: in Substance_Names; New_Val: Percent);

   function Get_Demand (Drug: in Substance_Names) return Level;
   procedure Set_Demand (Drug: in Substance_Names; New_Val: Level);

   function Get_Supply (Drug: in Substance_Names) return Level;
   procedure Set_Supply (Drug: in Substance_Names; New_Val: Level);

   function Get_Market_Rate (Drug: in Substance_Names) return Positive;
end Drug_Market;
