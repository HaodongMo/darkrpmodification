--[[---------------------------------------------------------------------------
F4 menu tab modification module.
---------------------------------------------------------------------------]]

local function createF4MenuTab()
    local HTML = vgui.Create( "HTML" )
    HTML:SetHTML( [[
<style>
    body {
        color: white;
        font-family: sans-serif;
    }
</style>

<h1 id="the-rules">The Rules</h1>
<p><strong>ArcRP is an Anarchy server. This means you shouldn&#39;t expect admins to get you out of in-game situations.</strong>
There is no NLR, no RDM, no &#39;/advert drop 500&#39;. Anyone saying this kind of shit will be mocked relentlessly. So long as you&#39;re having fun, and everyone else is too, it&#39;s fine.</p>
<p>With that in mind, the only rules, which should not be difficult to follow, are:</p>
<ul>
<li>No hacking.</li>
<li>No trying to crash the server.</li>
<li>Don&#39;t harass people.</li>
<li>Don&#39;t be racist, including using slurs.</li>
</ul>

]] )

    DarkRP.addF4MenuTab("Rules", HTML)

    local HTML2 = vgui.Create( "HTML" )
    HTML2:SetHTML( [[
<style>
    body {
        color: white;
        font-family: sans-serif;
    }
</style>
<h1 id="crafting-guide">Crafting Guide</h1>
<p>You can craft using a <strong>crafting machine</strong>, which only specific roles can buy. Acquire crafting ingredients (sold by the Shopkeeper) and place them in the machine. If you make a successful recipe, you&#39;ll receive the option to craft an item.</p>
<h2 id="gun-crafting-machine">Gun Crafting Machine</h2>
<ul>
<li><h3 id="component">Component</h3>
<p><em>Useful for creating other items, but does nothing by itself.</em></p>
<ul>
<li>1x Gear</li>
<li>1x Steel</li>
<li>1x Nails</li>
</ul>
</li>
<li><h3 id="pistol">Pistol</h3>
<p><em>Craft a random pistol.</em></p>
<ul>
<li>1x Component</li>
<li>1x Pipe</li>
</ul>
</li>
<li><h3 id="c4-detonator">C4 Detonator</h3>
<ul>
<li>1x Electronics</li>
</ul>
</li>
<li><h3 id="shotgun">Shotgun</h3>
<p><em>Craft a random shotgun.</em></p>
<ul>
<li>2x Component</li>
<li>1x Steel</li>
</ul>
</li>
<li><h3 id="submachine-gun">Submachine Gun</h3>
<p><em>Craft a random SMG.</em></p>
<ul>
<li>2x Component</li>
<li>1x Pipe</li>
</ul>
</li>
<li><h3 id="assault-rifle">Assault Rifle</h3>
<p><em>Craft a random assault rifle.</em></p>
<ul>
<li>3x Component</li>
</ul>
</li>
<li><h3 id="sniper-rifle">Sniper Rifle</h3>
<p><em>Craft a random sniper rifle.</em></p>
<ul>
<li>2x Component</li>
<li>1x Electronics</li>
</ul>
</li>
<li><h3 id="rocket-launcher">Rocket Launcher</h3>
<p><em>Craft an RPG-7.</em></p>
<ul>
<li>2x Component</li>
<li>1x Explosive Filler</li>
</ul>
</li>
<li><h3 id="grenade-launcher">Grenade Launcher</h3>
<p><em>Craft an M320 grenade launcher.</em></p>
<ul>
<li>1x Component</li>
<li>1x Explosive Filler</li>
<li>1x Pipe</li>
</ul>
</li>
</ul>
<h2 id="explosives-crafting-machine">Explosives Crafting Machine</h2>
<ul>
<li><h3 id="explosive-filler">Explosive Filler</h3>
<p><em>A stable explosive filler for creating explosive devices.</em></p>
<ul>
<li>1x Fuel</li>
<li>1x Chemicals</li>
</ul>
</li>
<li><h3 id="fuze">Fuze</h3>
<p><em>A detonating device for explosives. Does nothing by itself.</em></p>
<ul>
<li>1x Electronics</li>
<li>1x Wood</li>
</ul>
</li>
<li><h3 id="frag-grenade">Frag Grenade</h3>
<ul>
<li>1x Fuze</li>
<li>1x Explosive Filler</li>
</ul>
</li>
<li><h3 id="c4-charge">C4 Charge</h3>
<ul>
<li>1x Electronics</li>
<li>2x Explosive Filler</li>
</ul>
</li>
<li><h3 id="breaching-charge">Breaching Charge</h3>
<ul>
<li>1x Electronics</li>
<li>1x Explosive Filler</li>
</ul>
</li>
<li><h3 id="flashbang">Flashbang</h3>
<ul>
<li>1x Fuze</li>
<li>1x Paper</li>
</ul>
</li>
<li><h3 id="smoke-grenade">Smoke Grenade</h3>
<ul>
<li>1x Fuze</li>
<li>1x Fuel</li>
</ul>
</li>
<li><h3 id="thermite-grenade">Thermite Grenade</h3>
<ul>
<li>1x Fuze</li>
<li>1x Nails</li>
<li>1x Fuel</li>
</ul>
</li>
<li><h3 id="gas-grenade">Gas Grenade</h3>
<ul>
<li>1x Fuze</li>
<li>1x Chemicals</li>
</ul>
</li>
</ul>

]] )

    DarkRP.addF4MenuTab("Crafting Guide", HTML2)
end
hook.Add("F4MenuTabs", "MyCustomF4MenuTab", createF4MenuTab)
