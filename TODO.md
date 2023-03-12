change the architecture:

```lua
local BaseTrait1 = class()
local Trait1 = class(BaseTrait1)

function Trait1:_init(self)

end

mob_composer.api.register_trait(trait_name1, Trait1)

mob_composer.api.compose_mob(mob_name, {
  trait_name1 = {
    key1 = value1,
    key2 = value2,
    callback1 = function(self)  end,
  },
  trait_name2 = {
    key3 = value3,
    key4 = value4,
  },
})
```

-----------

idea:
    if mobs are solid (physical) they should try to move out of other mobs, as well as nodes. this would allow
    e.g. voice mobs from naturally ending up on top of each other.
      implement the physics like a bunch of same-charged particles


-----------

yl administration
* [mobs](https://gitea.your-land.de/your-land/administration/issues/144)
  * [use A* pathfinding](https://gitea.your-land.de/your-land/administration/issues/144#issuecomment-43572)
    * or perhaps investigate path-finding mods?
  * [memoize pathfinding results; black-list locations that we can't reach for some time](https://gitea.your-land.de/your-land/administration/issues/144#issuecomment-43572)
  * []w

yl bugs

main issue: https://gitea.your-land.de/your-land/bugtracker/issues/1362

# new mobs
* [Let's make a Sandworm-like mob](https://gitea.your-land.de/your-land/bugtracker/issues/96)
* [check out not so simple mobs (nssm)](https://gitea.your-land.de/your-land/bugtracker/issues/227)
* [https://content.minetest.net/packages/Liil/animalworld/](https://gitea.your-land.de/your-land/bugtracker/issues/250)
* [mob ideas: umbra causes blind. scorpion sting -> drunk. thieving mobs. a mob which damages armor heavily. a leech which attaches and drains life slowly. a mob which is totally invisible except a node box](https://gitea.your-land.de/your-land/bugtracker/issues/325)
* [blindness flies, which should be catchable](https://gitea.your-land.de/your-land/bugtracker/issues/331)
* [hot golems](https://gitea.your-land.de/your-land/bugtracker/issues/1310)
* [obsidian bird - mese monster/obsidian flan hybrid](https://gitea.your-land.de/your-land/bugtracker/issues/1373)

# new mob behavior

* [if mimes find chests, they should preferentially pretend to be a chest next to them](https://gitea.your-land.de/your-land/bugtracker/issues/2340)
* [when you right-click on a mime that's pretending to be a chest, it should "chomp" by opening-and-closing several times and making the appropriate sounds](https://gitea.your-land.de/your-land/bugtracker/issues/2327)
* [if a balrog kills you while you're carrying raw meat, it should end up cooked =D](https://gitea.your-land.de/your-land/bugtracker/issues/1811)
* [scorpions should cause tipsy](https://gitea.your-land.de/your-land/bugtracker/issues/286)
* [mimes have a chance of dropping an item which looks like a chest, is called a chest, but when you place it, spawns a mime.](https://gitea.your-land.de/your-land/bugtracker/issues/483)
* [if someone attacks a whale, the other whales should gang up and try to drown the player](https://gitea.your-land.de/your-land/bugtracker/issues/2017)

# mob behavior bugs/tweaks

* [waterlife spawns ignore protection](https://gitea.your-land.de/your-land/bugtracker/issues/861)
* [tamed mobs should be protected by default](https://gitea.your-land.de/your-land/bugtracker/issues/2189)
* [boss scorps spawn smaller scorps in and through walls](https://gitea.your-land.de/your-land/bugtracker/issues/2227)
* [mobs should drop more meat. almost all of them should drop at least some](https://gitea.your-land.de/your-land/bugtracker/issues/1680)
* [attacking petz doesn't wear tools](https://gitea.your-land.de/your-land/bugtracker/issues/28)
  * also, punching mobs_redo w/ un-wear-able tools causes wear
* [Elephants seem to get spawned partly inside the ground and zip down](https://gitea.your-land.de/your-land/bugtracker/issues/2048)
* [Remove mob fence and make all other fences not-jumpable](https://gitea.your-land.de/your-land/bugtracker/issues/49)
* [nether golems can punch you through a wall](https://gitea.your-land.de/your-land/bugtracker/issues/1188)
* [perched parrots wander if the player logs out](https://gitea.your-land.de/your-land/bugtracker/issues/1243)
* [animals which are set to "follow" should match the player's speed](https://gitea.your-land.de/your-land/bugtracker/issues/1245)

* petz glitch through ceilings in 1-block gaps

# ui bugs/tweaks

* [entities (mobs) should report what they are when you point your reticule at them](https://gitea.your-land.de/your-land/bugtracker/issues/2093)

# performance

* [fast-flying through a few dozen mapblocks full of unloaded birds caused a really significant lag spike](https://gitea.your-land.de/your-land/bugtracker/issues/2421)


* [killing docile mobs gives xp](https://gitea.your-land.de/your-land/bugtracker/issues/1388)
* [protectable fish, or a fish spawner](https://gitea.your-land.de/your-land/bugtracker/issues/1268)
* [show who protected a petz (owner)](https://gitea.your-land.de/your-land/bugtracker/issues/1547)
* [obsidian flans by snowball @ lava flan](https://gitea.your-land.de/your-land/bugtracker/issues/1561)
* [no callback to control how much wear is applied to a sword](https://gitea.your-land.de/your-land/bugtracker/issues/1510)
* [bees flying in water](https://gitea.your-land.de/your-land/bugtracker/issues/1644)
* [can't get wolves to attack on command](https://gitea.your-land.de/your-land/bugtracker/issues/1593)
* [animals are immune to lava](https://gitea.your-land.de/your-land/bugtracker/issues/1652)
* [petz whistel for calling back petz doesn't work](https://gitea.your-land.de/your-land/bugtracker/issues/1835)
* [bats and waterlife birds seem to spawn a bit too much...](https://gitea.your-land.de/your-land/bugtracker/issues/2077)
* [puppies bark when they're asleep O_O](https://gitea.your-land.de/your-land/bugtracker/issues/2175)
* [mob protection rune lvl 1 didnt save the sheeps](https://gitea.your-land.de/your-land/bugtracker/issues/2285)
* [dragons don't appear to be fireproof](https://gitea.your-land.de/your-land/bugtracker/issues/2320)
* [I tamed a chimp and before I could get out my lasso it climbed up a tree and fell out and died](https://gitea.your-land.de/your-land/bugtracker/issues/2432)
* [petz can still see/target you after using invis potion](https://gitea.your-land.de/your-land/bugtracker/issues/2509)
* [make golden apples or carrots work on animals too](https://gitea.your-land.de/your-land/bugtracker/issues/2638)
* [tamed petz die mysteriously](https://gitea.your-land.de/your-land/bugtracker/issues/2696)
* [hostile mob nests](https://gitea.your-land.de/your-land/bugtracker/issues/479)
* [land dolphins](https://gitea.your-land.de/your-land/bugtracker/issues/2851)
* [petz abandon their owners for no clear reason](https://gitea.your-land.de/your-land/bugtracker/issues/2854)
* [perma-baby or dwarf petz](https://gitea.your-land.de/your-land/bugtracker/issues/2710)
* [juggernaut (berserker)](https://gitea.your-land.de/your-land/bugtracker/issues/736)
* [caught snakes are never tame](https://gitea.your-land.de/your-land/bugtracker/issues/2946)
* [a zombie or necromancer, which, when it kills you, turns your avatar into a monster with a player nametag, which looks like your avatar, but attacks. The player would be forced to see the world out of the monster's eyes, at least for a while.](https://gitea.your-land.de/your-land/bugtracker/issues/326)
* [a rat attacked me through glass](https://gitea.your-land.de/your-land/bugtracker/issues/2967)
* [placed a node on my petz:kitten and it transcended](https://gitea.your-land.de/your-land/bugtracker/issues/2982)
