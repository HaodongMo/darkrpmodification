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
<p>All interpretation and enforcement of rules are at the discretion of admins.
Server rules are not in-game laws - what is acceptable gameplay can also be illegal.</p>
<ol>
<li>Conduct Rules<ol>
<li>Be excellent to each other.<ol>
<li>Don’t harass or abuse other players.</li>
<li>Do not target the same player repeatedly.</li>
<li>Do not act bigoted towards or use hate speech. In-character bigotry is only allowed if the other party does not object to it.</li>
<li>The n-word and its variants are not tolerated in any capacity.</li>
<li>Do not take in-character conflict into real life or vice versa.</li>
</ol>
</li>
<li>Do not use cheats or exploits to gain an unfair advantage or to disrupt/crash the server.</li>
<li>Do not use multiple accounts to avoid bans or to gain an unfair advantage.</li>
</ol>
</li>
<li>In-Character Rules<ol>
<li>Do not use OOC chat for in-character communication.</li>
<li>Your character name should be a believable, pronounceable name.</li>
<li>Your job name must be reasonable and cannot be misleading.</li>
<li>You are not allowed to attack someone without an external or material in-character reason.<ol>
<li>Reasons like being verbally provoked or being stolen from is acceptable.</li>
<li>Reasons like “my character is a psychopath” are not acceptable - there must be some outside motivation.</li>
</ol>
</li>
<li>You are not allowed to kill someone unless another rule specifies.<ol>
<li>When dealt sufficient damage, a player will become unconscious / knocked out, which does not kill them.</li>
</ol>
</li>
<li>If you die, you can no longer participate in the same fight you died in or act on information for your past life, such as taking revenge on your killer.<ol>
<li>Once a player is killed, their past crimes and wrongdoings should be forgiven.</li>
<li>Being knocked out does not count as being killed.</li>
</ol>
</li>
<li>It is acceptable to act on information gained via looking at a player’s name or job.</li>
</ol>
</li>
<li>Gameplay Rules<ol>
<li>A property is any building whose doors are bought by someone.</li>
<li>Do not place down props outdoors without purpose.<ol>
<li>Street stands, hobo homes, or setting up cover for a raid/robbery are acceptable examples of prop use.</li>
</ol>
</li>
<li>Do not attempt to push or hurt players with props.</li>
<li>Do not spawn or move props during combat.<ol>
<li>Using existing props as cover is acceptable.</li>
</ol>
</li>
</ol>
</li>
<li>Job Rules<ol>
<li>Police must enforce and obey the law.<ol>
<li>Police cannot collude with criminals or accept bribes unless the law permits.</li>
<li>Police must try to arrest someone if possible without killing them.</li>
</ol>
</li>
<li>Police must not act against the interests of the police force.</li>
<li>Gangsters are the only job that can commit violent crimes as defined in section 5.<ol>
<li>Police are allowed to be suspicious of gangsters without cause, but a cause is required to arrest them.</li>
</ol>
</li>
<li>If you have a job that involves offering a service, you must actually offer the service.<ol>
<li>You do not have to offer services to everyone. For example, supplying only members of your gang is acceptable.</li>
</ol>
</li>
</ol>
</li>
<li>Raid Rules<ol>
<li>A raid is an attempt to break and enter a property by a group of police or gangsters.<ol>
<li>Only gangsters or the police can be the attacker of a raid. Any job can defend a raid lethally.</li>
<li>A property cannot be raided by the same group twice in 30 minutes.</li>
<li>The same group of players cannot raid twice in 30 minutes.</li>
<li>After no attacker or defender is alive near the property, the raid is considered over and no further attacker can join.</li>
</ol>
</li>
<li>A police raid usually seeks to stop illegal activity in a property or arrest a wanted person.<ol>
<li>Police raids can only be conducted if there is evidence of illegal activity, and only with approval of at least 1 current highest ranking police officer.</li>
<li>Police raids must be announced in a chat message while near the property.</li>
<li>A property owner must be given a chance to allow police in peacefully before a raid is conducted.</li>
<li>During a police raid, the police cannot proactively attack defenders except in self-defense.</li>
<li>Defenders are allowed to kill attacking police during a raid.</li>
</ol>
</li>
<li>A gang raid usually seeks to loot and destroy a property or to kill rivals.<ol>
<li>Gang raids do not need to be announced.</li>
<li>The same property cannot be raided by the same players again in 15 minutes.</li>
<li>Non-gangsters cannot participate in a raid in any manner.</li>
<li>Non-gangsters can break into property, but it is not considered a raid and they cannot proactively attack the property owners.</li>
</ol>
</li>
</ol>
</li>
<li>Crime Rules<ol>
<li>There is no honor among thieves. Gangsters can sell one another out, cooperate with the authorities, etc. without restraint.</li>
<li>Gang crimes as defined below can only be committed by the Gangster job.<ol>
<li>Other crimes can be committed by any job even if it escalates into violence, but the criminal cannot proactively attack the victim or the police.</li>
<li>Civilians can solicit, assist or enable violent crimes, but cannot be directly involved in combat or fight the police together with gangsters.</li>
</ol>
</li>
<li>A robbery or mugging is the gang crime of taking someone’s belongings through threat of violence.<ol>
<li>Players not shown as viable robbery targets cannot be robbed of their belongings. If they are carrying objects in the world, that object can still be robbed.</li>
<li>The robber must announce the robbery to the victim and give them a chance to surrender. After any reaction or 5 seconds of no response, they are allowed to attack the victim.</li>
<li>The robber can only take what the robbery system lets them, as well as any objects already in the world.</li>
<li>The robber can not kill the victim, or attack the victim if they surrender.</li>
</ol>
</li>
<li>A gang raid is considered a gang crime (see section 5.3).</li>
<li>A bank robbery is the violent crime of taking money from the bank pallet.</li>
<li>A murder is the violent crime of killing someone.<ol>
<li>Gangsters can kill their hit target after requested through the hit system.</li>
<li>Gangsters can kill another gangster, or non-gangster jobs working with gangsters, in situations where violence was permitted by the rules.</li>
<li>Gangsters cannot kill police except as part of a raid or bank robbery.</li>
</ol>
</li>
<li>A kidnapping is the violent crime of trapping someone against their will.<ol>
<li>Do not kidnap someone without a very compelling in-character justification.</li>
<li>The kidnapper must immediately make a demand and either release or kill the victim within 5 minutes.</li>
<li>The same victim cannot be kidnapped again for 1 hour.</li>
</ol>
</li>
</ol>
</li>
</ol>

]] )

    DarkRP.addF4MenuTab("Rules", HTML)

    DarkRP.removeF4MenuTab("Jobs")
    DarkRP.removeF4MenuTab("Miscellaneous")
    DarkRP.removeF4MenuTab("Shipments")
end
hook.Add("F4MenuTabs", "MyCustomF4MenuTab", createF4MenuTab)
