extends Node

var gold_amount: int = 20
var last_used_item: InvItem
var shown_sell_container: VBoxContainer
var bring_items: Array[InvItem]
var used_items: Array[InvItem]
var common_chance = 65
var uncommon_chance = 85
var rare_chance = 98

signal gold_changed
signal health_changed
