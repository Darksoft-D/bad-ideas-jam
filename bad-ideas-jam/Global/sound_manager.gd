extends Node

@onready var battle_theme_2_full: AudioStreamPlayer = $BattleTheme2Full
@onready var battle_theme_2_calm: AudioStreamPlayer = $BattleTheme2Calm
@onready var shop_theme: AudioStreamPlayer = $ShopTheme
@onready var item_used: AudioStreamPlayer = $ItemUsed
@onready var hit: AudioStreamPlayer = $Hit
@onready var open_chest: AudioStreamPlayer = $OpenChest
@onready var item_equip: AudioStreamPlayer = $ItemEquip
@onready var item_pick_up: AudioStreamPlayer = $ItemPickUp
@onready var hover: AudioStreamPlayer = $Hover
@onready var deny: AudioStreamPlayer = $Deny
@onready var game_over: AudioStreamPlayer = $GameOver
@onready var pressed: AudioStreamPlayer = $Pressed
@onready var boss_theme_full: AudioStreamPlayer = $BossThemeFull
@onready var boss_theme_calm: AudioStreamPlayer = $BossThemeCalm
@onready var coin: AudioStreamPlayer = $Coin

func play_full():
	if !battle_theme_2_calm.playing:
		battle_theme_2_calm.play()
	if !battle_theme_2_full.playing:
		battle_theme_2_full.play()
	battle_theme_2_calm.volume_db = -80
	battle_theme_2_full.volume_db = -20

func play_calm():
	if !battle_theme_2_calm.playing:
		battle_theme_2_calm.play()
	if !battle_theme_2_full.playing:
		battle_theme_2_full.play()
	battle_theme_2_calm.volume_db = -20
	battle_theme_2_full.volume_db = -80

func play_boss_full():
	if !boss_theme_calm.playing:
		boss_theme_calm.play()
	if !boss_theme_full.playing:
		boss_theme_full.play()
	boss_theme_calm.volume_db = -80
	boss_theme_full.volume_db = -20

func play_boss_calm():
	if !boss_theme_calm.playing:
		boss_theme_calm.play()
	if !boss_theme_full.playing:
		boss_theme_full.play()
	boss_theme_calm.volume_db = -20
	boss_theme_full.volume_db = -80
