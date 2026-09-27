"""Execute the mission's pure SQF functions. No Arma world/network emulation."""
from pathlib import Path
import json
import unittest
import os
import re
import subprocess

MISSION=Path(__file__).resolve().parents[1]/'mission/BO2_Multiplayer.Altis'

def call(relative,args):
    source=(MISSION/relative).read_text()
    vm=os.environ.get('SQFVM',str(MISSION.parents[1]/'.tools/sqfvm'))
    program='BL_test={'+source+'}; diag_log ("BL_RESULT:" + str ('+json.dumps(args)+' call BL_test));'
    run=subprocess.run([vm,'-a','--suppress-welcome','--no-execute-print','--no-work-print','--sqf',program],text=True,capture_output=True,timeout=10)
    if run.returncode or '[ERR]' in run.stdout:
        raise AssertionError(run.stdout+run.stderr)
    match=re.search(r'BL_RESULT:(.*)',run.stdout)
    if not match: raise AssertionError('SQF-VM did not produce a result: '+run.stdout+run.stderr)
    return json.loads(match.group(1))

class ClassBudget(unittest.TestCase):
    def cost(self,c): return call('Functions/Client/fn_classCost.sqf',[c])
    def test_default_class_has_room_for_customization(self):
        self.assertEqual(self.cost([0,1,1,1,1,0,1,0,0]),6)
    def test_primary_choices_do_not_change_allocation(self):
        for primary in range(5): self.assertEqual(self.cost([primary,1,1,1,1,0,1,0,0]),6)
    def test_ten_point_build_and_over_budget_build(self):
        self.assertEqual(self.cost([0,1,1,1,1,1,1,1,0]),10)
        self.assertEqual(self.cost([0,1,1,1,1,1,1,1,1]),12)
    def test_perk_wildcard_cost_and_minimal_class(self):
        self.assertEqual(self.cost([0,0,0,0,0,0,0,0,0]),1)
        self.assertEqual(self.cost([0,0,0,0,0,1,1,0,0]),4)

class Domination(unittest.TestCase):
    def step(self,owner,meter,west,east):
        return call('Functions/Core/fn_captureStep.sqf',[owner,meter,west,east])
    def test_empty_point_retains_ownership(self):
        self.assertEqual(self.step(0,10,0,0),[0,10,False,False])
    def test_contested_point_never_changes_or_awards_capture(self):
        self.assertEqual(self.step(1,-4,6,1),[1,-4,True,False])
    def test_solo_capture_takes_ten_ticks(self):
        owner,meter=-1,0
        for tick in range(10):
            owner,meter,contested,captured=self.step(owner,meter,1,0)
            self.assertEqual(captured,tick==9)
        self.assertEqual((owner,meter),(0,10))
    def test_attack_neutralizes_before_it_changes_owner(self):
        self.assertEqual(self.step(0,1,0,1),[-1,0,False,False])
        self.assertEqual(self.step(-1,-9,0,1),[1,-10,False,True])
    def test_capture_speed_capped_and_meter_clamped(self):
        self.assertEqual(self.step(-1,0,6,0),[-1,3,False,False])
        self.assertEqual(self.step(-1,9,6,0),[0,10,False,True])
    def test_owned_point_cannot_repeat_capture_award(self):
        self.assertEqual(self.step(0,10,1,0),[0,10,False,False])


class RespawnProtocol(unittest.TestCase):
    def ack(self,args): return call('Functions/Core/fn_deploymentAckValid.sqf',args)
    def delivery(self,args): return call('Functions/Core/fn_deliveryAction.sqf',args)
    def test_only_outstanding_ticket_and_round_are_accepted(self):
        self.assertTrue(self.ack([7,2,7,2,2]))
        for args in [[7,2,6,2,2],[7,2,7,1,2],[7,2,7,2,3],[0,2,0,2,2]]:
            self.assertFalse(self.ack(args))
    def test_first_delivery_applies_kit(self): self.assertEqual(self.delivery([-1,-1,7,2]),2)
    def test_retry_only_acknowledges_without_refilling(self): self.assertEqual(self.delivery([7,2,7,2]),1)
    def test_delayed_old_delivery_is_rejected(self): self.assertEqual(self.delivery([8,2,7,2]),0)
    def test_same_ticket_cannot_be_reused_for_another_round(self): self.assertEqual(self.delivery([7,2,7,3]),0)
    def test_next_round_new_ticket_applies(self): self.assertEqual(self.delivery([7,2,8,3]),2)

if __name__=='__main__': unittest.main()

class Population(unittest.TestCase):
    def test_auto_density_and_limits(self):
        for radius, expected in [(75,6),(225,12),(300,16),(1000,16)]:
            self.assertEqual(call('Functions/Core/fn_population.sqf',[radius,0]),expected)
    def test_manual_override(self):
        for requested, expected in [(1,1),(8,8),(12,12),(99,16)]:
            self.assertEqual(call('Functions/Core/fn_population.sqf',[225,requested]),expected)
