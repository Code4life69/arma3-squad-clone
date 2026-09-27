from pathlib import Path
import unittest
from config_reader import parse
ROOT=Path(__file__).resolve().parents[1]
M=ROOT/'mission/BO2_Multiplayer.Altis'

class MissionConfig(unittest.TestCase):
    def test_mission_entity_counts_slots_ids_and_markers(self):
        root=parse((M/'mission.sqm').read_text());self.assertEqual(root.values['version'],53)
        entities=root.classes['Mission'].classes['Entities']
        ids=[];players=[];markers={}
        def walk(node):
            self.assertEqual(node.values['items'],len(node.classes))
            for entity in node.classes.values():
                ids.append(entity.values['id'])
                kind=entity.values['dataType']
                if kind=='Group':walk(entity.classes['Entities'])
                elif kind=='Object':players.append(entity)
                elif kind=='Marker':markers[entity.values['name']]=entity
        walk(entities)
        self.assertEqual(len(ids),len(set(ids)))
        self.assertEqual(len(players),32)
        self.assertEqual(sum(p.classes['Attributes'].values.get('isPlayer',0) for p in players),1)
        self.assertTrue(all(p.classes['Attributes'].values['isPlayable']==1 for p in players))
        self.assertEqual(set(markers),{'respawn_west','respawn_east'})
        for marker in markers.values():
            x,height,y=marker.values['position']
            self.assertTrue(3400<x<3900 and 12900<y<13300)
        self.assertGreater(root.classes['EditorData'].classes['ItemIDProvider'].values['nextID'],max(ids))
    def test_description_respawn_and_registered_source_paths(self):
        root=parse((M/'description.ext').read_text())
        self.assertEqual(root.values['respawn'],3)
        self.assertEqual(root.values['respawnDelay'],3)
        self.assertEqual(root.values['respawnTemplates'],[])
        self.assertEqual(root.values['respawnDialog'],0)
        for category in root.classes['CfgFunctions'].classes['BL'].classes.values():
            folder=category.values['file'].replace('\\','/')
            for function in category.classes:
                self.assertTrue((M/folder/f'fn_{function}.sqf').is_file(),function)
    def test_truncated_mission_rejected(self):
        with self.assertRaises(ValueError):parse((M/'mission.sqm').read_text()[:-4])
    def test_duplicate_entity_class_rejected(self):
        with self.assertRaises(ValueError):parse('class Entities { class Item0 {}; class Item0 {}; };')
    def test_source_event_passes_new_life_and_network_is_confirmed(self):
        event=(M/'onPlayerRespawn.sqf').read_text()
        self.assertIn('[_newUnit] spawn BL_fnc_prepare',event)
        prepare=(M/'Functions/Client/fn_prepare.sqf').read_text()
        self.assertNotIn('BL_prepared',prepare)
        self.assertIn('netId _unit',prepare)
        request=(M/'Functions/Server/fn_request.sqf').read_text()
        self.assertIn('BL_fnc_deploymentAckValid',request)
        self.assertIn('_r param [12,""]',request)
        receive=(M/'Functions/Client/fn_receive.sqf').read_text()
        self.assertIn('netId player != _life',receive)
        self.assertIn('BL_fnc_deliveryAction',receive)
        self.assertTrue((M/'Functions/Client/fn_lifeLoop.sqf').is_file())
