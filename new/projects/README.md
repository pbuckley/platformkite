## Animals

:moose:
:donkey:
:jellyfish:
:cockroach:
:bison:
:beaver:
:flamingo:
:skunk:
:orangutan:
:swan:
:hippopotamus:
:peacock:
:llama:

## Flowers/Trees

leaves :leaves:
fallen_leaf :fallen_leaf:
maple_leaf :maple_leaf:
four_leaf_clover :four_leaf_clover:
herb :herb:
sunflower :sunflower:
hibiscus :hibiscus:
rose :rose:
cherry_blossom :cherry_blossom:
tulip :tulip:
cactus :cactus:
palm_tree :palm_tree:
deciduous_tree :deciduous_tree:
evergreen_tree :evergreen_tree:
seedling :seedling:

## Vegetables

:onion:
:garlic:
:broccoli:
:carrot:

## Fruits

:mango:
:coconut:
:kiwifruit:

## Sweets

:fondue:
:waffle:
:cupcake:
:bagel:
:moon_cake:

## Savoury

:dumpling:

## Seafood

:crab:

## Travel

:motor_boat:
:small_airplane:
:motor_scooter:
:canoe:
:skateboard:
:auto_rickshaw:
:pickup_truck:
:roller_skate:
:car:
:bus:
:train:

1. Create Cluster (depends_on: null)
2. Create Queues (depends_on: cluster)
3. Create Tokens (depends_on: cluster)
4. Create Agent Stack (depends_on: cluster, queue, token)
5.
