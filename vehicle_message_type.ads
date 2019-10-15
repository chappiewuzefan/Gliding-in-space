-- Suggestions for packages which might be useful:
with Ada.Real_Time;         use Ada.Real_Time;
with Vectors_3D;            use Vectors_3D;
with Ada.Containers.Ordered_Sets;
with Swarm_Structures_Base; use Swarm_Structures_Base;

package Vehicle_Message_Type is

   package Integer_Sets is new Ada.Containers.Ordered_Sets
     (Element_Type => Positive);
   use Integer_Sets;

   -- Replace this record definition by what your vehicles need to communicate.
   type Inter_Vehicle_Messages is
      record
         Globe_Position : Vector_3D;
         Charge_Avaliable : Boolean := True;
         Time_Checker : Time;
         Set_For_Alive : Set;
         globe_velocity : Velocities;
      end record;

end Vehicle_Message_Type;
