-- Have a discussion about stage d with Xu Si u6714758 and we got the similar idea about controlling vehicles number
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-------------------------The best Stage b & c-----------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------

--  with Exceptions;                     use Exceptions;
--  with Vectors_3D;                     use Vectors_3D;
--  with Vehicle_Interface;              use Vehicle_Interface;
--  with Swarm_Structures_Base;          use Swarm_Structures_Base;
--  with Vehicle_Message_Type;           use Vehicle_Message_Type;
--  with Real_Type;                      use Real_Type;
--  with Ada.Numerics;                   use Ada.Numerics;
--  with Ada.Real_Time;                  use Ada.Real_Time;
--
--  package body Vehicle_Task_Type is
--
--     task body Vehicle_Task is
--
--        Vehicle_No : Positive;
--        Vehicle_Class : Natural;
--        Find_It : Boolean := False;
--        Angle_Vehicle : Long_Float := 0.0;
--        Outer_Message : Inter_Vehicle_Messages;
--        Local_Message : Inter_Vehicle_Messages;
--
--        -- The outer four circles
--        function Outer_Circle (radius : Real_Type.Real; distance : Real_Type.Real) return Vectors_3D.Vector_3D is
--        begin
--           if Vehicle_Class = 0 then -- XZ circle
--              return (Local_Message.Globe_Position (x) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle) + distance,
--                      Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle),
--                      Local_Message.Globe_Position (z));
--           elsif Vehicle_Class = 1 then -- XZ circle
--              return (Local_Message.Globe_Position (x) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle) - distance,
--                      Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle),
--                      Local_Message.Globe_Position (z));
--           elsif Vehicle_Class = 2 then -- XZ circle
--              return (Local_Message.Globe_Position (x),
--                      Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle),
--                      Local_Message.Globe_Position (z) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle) + distance);
--           else                         -- XZ circle
--              return (Local_Message.Globe_Position (x),
--                      Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle),
--                      Local_Message.Globe_Position (z) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle) - distance);
--           end if;
--        end Outer_Circle;
--
--        -- The inner circle
--        function Inner_Circle (radius : Real_Type.Real) return Vectors_3D.Vector_3D is
--        begin
--           return (Local_Message.Globe_Position (x) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle),
--                   Local_Message.Globe_Position (y),
--                   Local_Message.Globe_Position (z) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle));
--        end Inner_Circle;
--
--        -- Checking the time to get the newest message
--        procedure Check_Info is
--        begin
--           -- if the receiving time is newest then updating the local information
--           if Outer_Message.Time_Checker > Local_Message.Time_Checker then
--              Local_Message := Outer_Message;
--           elsif Outer_Message.Time_Checker < Local_Message.Time_Checker then
--              Outer_Message := Local_Message;
--           end if;
--        end Check_Info;
--
--     begin
--
--        accept Identify (Set_Vehicle_No : Positive; Local_Task_Id : out Task_Id) do
--           Vehicle_No     := Set_Vehicle_No;
--           Local_Task_Id  := Current_Task;
--           Vehicle_Class := Vehicle_No mod 4; -- from 0 to 3
--           Angle_Vehicle := Long_Float (Vehicle_No mod 16) * (Pi / 8.0);
--        end Identify;
--
--        select
--
--           Flight_Termination.Stop;
--
--        then abort
--
--           Outer_task_loop : loop
--
--              Wait_For_Next_Physics_Update;
--
--              -- Try to find the energy globe
--              declare
--                 Try_Find_Globes : constant Energy_Globes := Energy_Globes_Around;
--              begin
--                 for i in Try_Find_Globes'Range loop
--                    Find_It := Try_Find_Globes (i).Position'Valid_Scalars;
--                    if Find_It then
--                       Outer_Message.Globe_Position := Try_Find_Globes (i).Position;
--                       -- only generate new time point when it finds the position of the globe
--                       Outer_Message.Time_Checker := Clock;
--                       Outer_Message.Charge_Avaliable := True;
--                       Local_Message := Outer_Message;
--                       Send (Outer_Message);
--                       Find_It := False;
--                       exit;
--                    end if;
--                 end loop;
--              end;
--
--              Set_Throttle (0.9);
--
--              -- Updating the angle for each physics update
--              Angle_Vehicle := Angle_Vehicle + Pi / 60.0;
--
--              -- The emergency case when the charge level below 30%
--              if Current_Charge < 0.3 then
--                 if Messages_Waiting then
--                    Receive (Outer_Message);
--                    Check_Info;
--                 end if;
--                 Outer_Message.Charge_Avaliable := False;
--                 Local_Message.Charge_Avaliable := False;
--                 Send (Outer_Message);
--                 Set_Destination (Local_Message.Globe_Position + Local_Message.globe_velocity * 0.2);
--                 Set_Throttle (Full_Throttle);
--
--              -- The normal case
--              elsif Messages_Waiting then
--                 Receive (Outer_Message);
--                 Check_Info;
--                 if Current_Charge < 0.6 then
--                    if Local_Message.Charge_Avaliable then
--                       Outer_Message.Charge_Avaliable := False;
--                       Local_Message.Charge_Avaliable := False;
--                       Set_Destination (Inner_Circle (0.16));
--                       Set_Throttle (0.6);
--                    else
--                       Set_Destination (Inner_Circle (0.16));
--                       Set_Throttle (0.6);
--                    end if;
--                 elsif Current_Charge < 0.7 then
--                    Set_Destination (Inner_Circle (0.1));
--                 else
--                    Set_Destination (Outer_Circle (0.08, 0.16));
--                    Set_Throttle (0.6);
--                 end if;
--                 Send (Outer_Message);
--              else
--                 Set_Destination (Outer_Circle (0.08, 0.16));
--              end if;
--
--           end loop Outer_task_loop;
--        end select;
--     exception
--        when E : others => Show_Exception (E);
--     end Vehicle_Task;
--  end Vehicle_Task_Type;

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-------------------------------Stage d------------------------------------
------------Also support stage b & c but not very good pattern------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------

with Exceptions;                     use Exceptions;
with Vectors_3D;                     use Vectors_3D;
with Vehicle_Interface;              use Vehicle_Interface;
with Swarm_Structures_Base;          use Swarm_Structures_Base;
with Vehicle_Message_Type;           use Vehicle_Message_Type;
with Real_Type;                      use Real_Type;
with Ada.Numerics;                   use Ada.Numerics;
with Ada.Real_Time;                  use Ada.Real_Time;
with Ada.Text_IO;                    use Ada.Text_IO;
with Ada.Containers;                 use Ada.Containers;

package body Vehicle_Task_Type is

   task body Vehicle_Task is

      Vehicle_No : Positive;
      Vehicle_Class : Natural;
      Find_It : Boolean := False;
      Angle_Vehicle : Long_Float := 0.0;
      Outer_Message : Inter_Vehicle_Messages;
      Local_Message : Inter_Vehicle_Messages;
      Target_No : Natural;

      -- The outer four circles
      function Outer_Circle (radius : Real_Type.Real; distance : Real_Type.Real) return Vectors_3D.Vector_3D is
      begin
         if Vehicle_Class = 0 then -- XZ circle
            return (Local_Message.Globe_Position (x) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle) + distance,
                    Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle),
                    Local_Message.Globe_Position (z));
         elsif Vehicle_Class = 1 then -- XZ circle
            return (Local_Message.Globe_Position (x) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle) - distance,
                    Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle),
                    Local_Message.Globe_Position (z));
         elsif Vehicle_Class = 2 then -- XZ circle
            return (Local_Message.Globe_Position (x),
                    Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle),
                    Local_Message.Globe_Position (z) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle) + distance);
         else                         -- XZ circle
            return (Local_Message.Globe_Position (x),
                    Local_Message.Globe_Position (y) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle),
                    Local_Message.Globe_Position (z) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle) - distance);
         end if;
      end Outer_Circle;

      -- The inner circle
      function Inner_Circle (radius : Real_Type.Real) return Vectors_3D.Vector_3D is
      begin
         return (Local_Message.Globe_Position (x) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle),
                 Local_Message.Globe_Position (y),
                 Local_Message.Globe_Position (z) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle));
      end Inner_Circle;

      -- Checking the time to get the newest message
      procedure Check_Info is
      begin
         -- if the receiving time is newest then updating the local information
         if Outer_Message.Time_Checker > Local_Message.Time_Checker then
            -- Checking the survival set's length
            if Natural (Outer_Message.Set_For_Alive.Length) < Target_No then
               Outer_Message.Set_For_Alive.Include (Vehicle_No);
               Local_Message := Outer_Message;
            elsif Natural (Outer_Message.Set_For_Alive.Length) > Target_No then
               Outer_Message.Set_For_Alive.Exclude (Vehicle_No);
               Local_Message := Outer_Message;
            else
               Local_Message := Outer_Message;
            end if;
         -- Upload local information to override the order one
         elsif Outer_Message.Time_Checker < Local_Message.Time_Checker then
            Outer_Message := Local_Message;
         end if;
      end Check_Info;

   begin

      accept Identify (Set_Vehicle_No : Positive; Local_Task_Id : out Task_Id) do
         Vehicle_No     := Set_Vehicle_No;
         Local_Task_Id  := Current_Task;
         Vehicle_Class := Vehicle_No mod 4; -- from 0 to 3
         Angle_Vehicle := Long_Float (Vehicle_No mod 16) * (Pi / 8.0);
         Target_No := Target_No_of_Elements;
      end Identify;

      Set_Throttle (0.9);

      select

         Flight_Termination.Stop;

      then abort

         Outer_task_loop : loop

            Wait_For_Next_Physics_Update;

            -- Try to find the energy globe
            declare
               Try_Find_Globes : constant Energy_Globes := Energy_Globes_Around;
            begin
               for i in Try_Find_Globes'Range loop
                  Find_It := Try_Find_Globes (i).Position'Valid_Scalars;
                  if Find_It then
                     Outer_Message.Globe_Position := Try_Find_Globes (i).Position;
                     -- only generate new time point when it finds the position of the globe
                     Outer_Message.Time_Checker := Clock;
                     Outer_Message.Charge_Avaliable := True;
                     Local_Message := Outer_Message;
                     Put_Line ("How many " & Count_Type'Image (Outer_Message.Set_For_Alive.Length) & " alive");
                     Send (Outer_Message);
                     Find_It := False;
                     exit;
                  end if;
               end loop;
            end;

            Set_Throttle (0.9);

            -- The emergency case when charge level below 40%
            if Current_Charge < 0.4 then

               if Messages_Waiting then
                  Receive (Outer_Message);
                  Check_Info;
               end if;

               -- In order to improve performance in here I use if else
               -- But it's ok to uncomment it.

--                 while Messages_Waiting loop
--                    Receive (Outer_Message);
--                    Check_Info;
--                 end loop;
               if Local_Message.Set_For_Alive.Contains (Vehicle_No) then
                  Outer_Message.Charge_Avaliable := False;
                  Local_Message.Charge_Avaliable := False;
                  Send (Outer_Message);
                  Set_Destination (Local_Message.Globe_Position + Local_Message.globe_velocity * 0.2);
                  Set_Throttle (Full_Throttle);
               else
                  Set_Throttle (Full_Throttle);
               end if;

            -- The normal case
            elsif Messages_Waiting then
               Receive (Outer_Message);
               Check_Info;
               if Local_Message.Set_For_Alive.Contains (Vehicle_No) then
                  if Current_Charge < 0.6 then
                     if Local_Message.Charge_Avaliable then
                        Outer_Message.Charge_Avaliable := False;
                        Local_Message.Charge_Avaliable := False;
                        Set_Destination (Inner_Circle (Long_Float (Current_Charge) * 0.1));
                        Set_Throttle (0.6);
                     else
                        Set_Destination (Inner_Circle (Long_Float (Current_Charge) * 0.1));
                        Set_Throttle (0.6);
                     end if;
                  elsif Current_Charge < 0.7 then
                     Set_Destination (Inner_Circle (Long_Float (Current_Charge) * 0.1));
                  else
                     Set_Destination (Outer_Circle (Long_Float (Current_Charge) * 0.05 / 2.0, Long_Float (Current_Charge) * 0.1));
                     Set_Throttle (0.6);
                  end if;
                  Angle_Vehicle := Angle_Vehicle + Pi / 120.0;
                  Send (Outer_Message);
               else
                  Set_Throttle (Full_Throttle);
               end if;
            else
               Set_Throttle (Full_Throttle);
            end if;

         end loop Outer_task_loop;
      end select;
   exception
      when E : others => Show_Exception (E);
   end Vehicle_Task;
end Vehicle_Task_Type;

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-------------------Attempt 1 (only support stage a)-----------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------

--  with Exceptions;                     use Exceptions;
--  with Vectors_3D;                     use Vectors_3D;
--  with Vehicle_Interface;              use Vehicle_Interface;
--  with Swarm_Structures_Base;          use Swarm_Structures_Base;
--
--  package body Vehicle_Task_Type is
--
--     gloe : Vector_3D;
--
--     task body Vehicle_Task is
--
--        Vehicle_No : Positive; -- You will want to take the pragma out, once you use the "Vehicle_No"
--        pragma Unreferenced (Vehicle_No);
--        find_it : Boolean := False;
--
--     begin
--
--        accept Identify (Set_Vehicle_No : Positive; Local_Task_Id : out Task_Id) do
--           Vehicle_No     := Set_Vehicle_No;
--           Local_Task_Id  := Current_Task;
--        end Identify;
--
--        select
--
--           Flight_Termination.Stop;
--
--        then abort
--
--           -- Put_Line (Float'Image (Float (vehicle_gas_class) * 0.09));
--
--           Outer_task_loop : loop
--
--              Wait_For_Next_Physics_Update;
--
--              -- Try to find the energy globe
--              declare
--                 try_find_globes : constant Energy_Globes := Energy_Globes_Around;
--              begin
--                 for i in try_find_globes'Range loop
--                    find_it := try_find_globes (i).Position'Valid_Scalars;
--                    if find_it then
--                       gloe := try_find_globes (i).Position;
--                       find_it := False;
--                       exit;
--                    end if;
--                 end loop;
--              end;
--
--              Set_Throttle (0.9);
--
--              -- Different cases for different charge level
--              if Current_Charge < 0.3 then
--                 Set_Destination (gloe);
--                 Set_Throttle (Full_Throttle);
--              else
--                 Set_Destination (gloe + (0.1, 0.1, 0.1));
--                 Set_Throttle (0.6);
--              end if;
--
--           end loop Outer_task_loop;
--        end select;
--     exception
--        when E : others => Show_Exception (E);
--     end Vehicle_Task;
--  end Vehicle_Task_Type;

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-------------------Attempt 2 (support stage b & c)------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------

--  with Exceptions;                     use Exceptions;
--  with Vectors_3D;                     use Vectors_3D;
--  with Vehicle_Interface;              use Vehicle_Interface;
--  with Swarm_Structures_Base;          use Swarm_Structures_Base;
--  with Vehicle_Message_Type;           use Vehicle_Message_Type;
--  with Real_Type;                      use Real_Type;
--  with Ada.Numerics;                   use Ada.Numerics;
--  with Ada.Real_Time;                  use Ada.Real_Time;
--
--  package body Vehicle_Task_Type is
--
--     task body Vehicle_Task is
--
--        Vehicle_No : Positive;
--        Vehicle_Class : Natural;
--        pragma Unreferenced (Vehicle_Class);
--        Find_It : Boolean := False;
--        Angle_Vehicle : Long_Float := 0.0;
--        Outer_Message : Inter_Vehicle_Messages;
--        Local_Message : Inter_Vehicle_Messages;
--
--        -- The inner circle
--        function Inner_Circle (radius : Real_Type.Real) return Vectors_3D.Vector_3D is
--        begin
--           return (Local_Message.Globe_Position (x) + radius * Real_Elementary_Functions.Sin (Angle_Vehicle),
--                   Local_Message.Globe_Position (y),
--                   Local_Message.Globe_Position (z) + radius * Real_Elementary_Functions.Cos (Angle_Vehicle));
--        end Inner_Circle;
--
--        -- Checking timestamps to get the newest message
--        procedure Check_Info is
--        begin
--           -- if the receiving time is newest then updating the local information
--           if Outer_Message.Time_Checker > Local_Message.Time_Checker then
--              Local_Message := Outer_Message;
--           elsif Outer_Message.Time_Checker < Local_Message.Time_Checker then
--              Outer_Message := Local_Message;
--           end if;
--        end Check_Info;
--
--     begin
--
--        accept Identify (Set_Vehicle_No : Positive; Local_Task_Id : out Task_Id) do
--           Vehicle_No     := Set_Vehicle_No;
--           Local_Task_Id  := Current_Task;
--           Vehicle_Class := Vehicle_No mod 4; -- from 0 to 3
--           Angle_Vehicle := Long_Float (Vehicle_No mod 16) * (Pi / 8.0);
--        end Identify;
--
--        select
--
--           Flight_Termination.Stop;
--
--        then abort
--
--           Outer_task_loop : loop
--
--              Wait_For_Next_Physics_Update;
--
--              -- Try to find the energy globe
--              declare
--                 Try_Find_Globes : constant Energy_Globes := Energy_Globes_Around;
--              begin
--                 for i in Try_Find_Globes'Range loop
--                    Find_It := Try_Find_Globes (i).Position'Valid_Scalars;
--                    if Find_It then
--                       Outer_Message.Globe_Position := Try_Find_Globes (i).Position;
--                       -- only generate new time point when it finds the position of the globe
--                       Outer_Message.Time_Checker := Clock;
--                       Outer_Message.Charge_Avaliable := True;
--                       Local_Message := Outer_Message;
--                       Send (Outer_Message);
--                       Find_It := False;
--                       exit;
--                    end if;
--                 end loop;
--              end;
--
--              Set_Throttle (0.9);
--
--              -- Emergency case when current charge level is below 30%
--               if Current_Charge < 0.3 then
--                 Receive (Outer_Message);
--                 Check_Info;
--                 Outer_Message.Charge_Avaliable := False;
--                 Local_Message.Charge_Avaliable := False;
--                 Set_Destination (Local_Message.Globe_Position);
--                 Set_Throttle (Full_Throttle);
--
--               -- Normal cases
--               elsif Messages_Waiting then
--                 Receive (Outer_Message);
--                 Check_Info;
--                 if Current_Charge < 0.5 then
--                    Outer_Message.Charge_Avaliable := False;
--                    Local_Message.Charge_Avaliable := False;
--                    Set_Destination (Local_Message.Globe_Position);
--                    Set_Throttle (Full_Throttle);
--                 elsif Current_Charge < 0.7 then
--                    Set_Destination (Inner_Circle (Long_Float (Current_Charge) * 0.4));
--                 else
--                    Set_Destination (Inner_Circle (Long_Float (Current_Charge) * 0.4));
--                 end if;
--                 Send (Outer_Message);
--               end if;
--
--              Angle_Vehicle := Angle_Vehicle + Pi / 120.0;
--
--           end loop Outer_task_loop;
--        end select;
--     exception
--        when E : others => Show_Exception (E);
--     end Vehicle_Task;
--  end Vehicle_Task_Type;
