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
end
hook.Add("F4MenuTabs", "MyCustomF4MenuTab", createF4MenuTab)
