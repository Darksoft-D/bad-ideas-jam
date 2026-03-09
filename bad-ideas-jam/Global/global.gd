extends Node

var gold_amount: int = 20
var last_used_item: InvItem
var shown_sell_container: VBoxContainer
var bring_items: Array[PackedScene]
var used_items: Array[InvItem]

signal gold_changed
signal health_changed
