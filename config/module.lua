return {
    -- type of machine to handle together
    default_module_row_count = 6,
    module_slot_max = 4,
    machine_prod_disallow = {
        ['beacon'] = true
    },
    machine_craft = {
        ['assembling-machine-2'] = true,
        ['assembling-machine-3'] = true,
        ['electric-furnace'] = true,
        ['oil-refinery'] = true,
        ['chemical-plant'] = true,
        ['centrifuge'] = true,
        ['rocket-silo'] = true
    },
    machine = {
        ['electric-mining-drill'] = 'effectivity-module',
        ['pumpjack'] = 'effectivity-module',
        ['assembling-machine-2'] = 'productivity-module',
        ['assembling-machine-3'] = 'productivity-module-3',
        ['electric-furnace'] = 'productivity-module-3',
        ['beacon'] = 'speed-module-3',
        ['oil-refinery'] = 'productivity-module-3',
        ['chemical-plant'] = 'productivity-module-3',
        ['centrifuge'] = 'productivity-module-3',
        ['lab'] = 'productivity-module-3',
        ['rocket-silo'] = 'productivity-module-3'
    },
    module_allowed = {
        ['advanced-circuit'] = true,
        ['automation-science-pack'] = true,
        ['battery'] = true,
        ['chemical-science-pack'] = true,
        ['copper-cable'] = true,
        ['copper-plate'] = true,
        ['electric-engine-unit'] = true,
        ['electronic-circuit'] = true,
        ['empty-barrel'] = true,
        ['engine-unit'] = true,
        ['explosives'] = true,
        ['flying-robot-frame'] = true,
        ['iron-gear-wheel'] = true,
        ['iron-plate'] = true,
        ['iron-stick'] = true,
        ['logistic-science-pack'] = true,
        ['low-density-structure'] = true,
        ['lubricant'] = true,
        ['military-science-pack'] = true,
        ['nuclear-fuel'] = true,
        ['plastic-bar'] = true,
        ['processing-unit'] = true,
        ['production-science-pack'] = true,
        ['rocket-control-unit'] = true,
        ['rocket-fuel'] = true,
        ['rocket-part'] = true,
        ['steel-plate'] = true,
        ['stone-brick'] = true,
        ['sulfur'] = true,
        ['sulfuric-acid'] = true,
        ['uranium-fuel-cell'] = true,
        ['utility-science-pack'] = true,
        ['basic-oil-processing'] = true,
        ['advanced-oil-processing'] = true,
        ['coal-liquefaction'] = true,
        ['heavy-oil-cracking'] = true,
        ['light-oil-cracking'] = true,
        ['solid-fuel-from-light-oil'] = true,
        ['solid-fuel-from-petroleum-gas'] = true,
        ['solid-fuel-from-heavy-oil'] = true,
        ['uranium-processing'] = true,
        ['nuclear-fuel-reprocessing'] = true,
        ['kovarex-enrichment-process'] = true
    }
}
