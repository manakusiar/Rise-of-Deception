extends Node
class_name AbilityEffect

## ---------------------------------------------------------------------------
## LOGIC LAYER  (the "how")
## ---------------------------------------------------------------------------
## Base class for spell behaviour. Each ability's effect_scene has a root that
## extends AbilityEffect and overrides activate(). The AbilityComponent
## instantiates this node, attaches it to the caster, hands it the DataAbility
## and lets it do its thing (spawn a projectile, dash the player, spawn
## particles, play sound, apply damage...), then the effect frees itself.
##
## Why a controller node instead of putting logic on the projectile?
##   - complex abilities (multi-stage, delayed, summoning) get a real lifecycle
##   - it decouples spell LOGIC from spell VISUALS (the projectile prefab)
##   - self-abilities (dash/buff) and world-abilities (fireball) share one shape
## ---------------------------------------------------------------------------

var source: Node          # the entity that cast it (usually the player)
var data: DataAbility     # the DataAbility it was spawned from

func activate(p_source: Node, aim_direction: Vector2, p_data: DataAbility) -> void:
	source = p_source
	data = p_data
	# Override me in subclasses.

## Convenience: read a tuned value straight from the data resource.
func get_damage() -> float:
	return data.base_damage if data != null else 0.0

## The world root projectiles etc. should be parented to (caster's parent).
func world_root() -> Node:
	return source.get_parent() if source != null else null

## Call when the effect has done its job.
func finish() -> void:
	queue_free()
