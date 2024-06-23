--[[---------------------------------------------------------------------------
F4 menu tab modification module.
---------------------------------------------------------------------------]]

local tabName = "The Law"

local function createF4MenuTab()
    local HTML = vgui.Create( "HTML" )
    HTML:SetHTML( [[
<style>
    body {
        color: white;
        font-family: sans-serif;
    }
</style><h1 id="the-law">The Law</h1>
<h2 id="-0-metagame">§0 : Metagame</h2>
<ol>
<li><p>Using software external to the intended limits of the game to gain
an advantage is considered Hacking, and will result in a permanent
direct ban by administrators.</p>
</li>
<li><p>Attempting to crash the server will result in a permanent direct ban
by administrators.</p>
</li>
<li><p>Attempting to harm other players in real life in any way will result
in a permanent direct ban by administrators, and, where relevant, a
report to the appropriate authorities.</p>
<ol>
<li><p>Examples include, but are not limited to:</p>
</li>
<li><p>Committing any real-world crime,</p>
</li>
<li><p>De-anonymizing players (“Doxxing&quot;),</p>
</li>
<li><p>Defaming the character of other players in a malicious way,</p>
</li>
<li><p>Any type of scheme or conspiracy to harm another player in any
way which does not take place solely within the confines of the
game.</p>
</li>
</ol>
</li>
</ol>
<!-- -->
<ol>
<li><p>All else is handled by the in-game police. Administrator action will
not be taken for any other actions than the ones listed here in
section 0.</p>
</li>
<li><p>You will be mercilessly mocked for mentioning any of the following:</p>
<ol>
<li><p>“RDM”</p>
</li>
<li><p>“FailRP”</p>
</li>
<li><p>“advert mug drop 500”</p>
</li>
<li><p>“advert raid”</p>
</li>
<li><p>“New Life Rule”</p>
</li>
<li><p>“Minge”</p>
</li>
<li><p>“Propclimb”</p>
</li>
</ol>
</li>
</ol>
<p>§1 : Definitions and Due Process</p>
<ol>
<li><p>All police officers are required to observe and uphold The Law.</p>
</li>
<li><p>A crime is any breach of the law.</p>
</li>
<li><p>A police officer is anyone who holds a Police role.</p>
</li>
<li><p>Anyone suspected of a crime is entitled to a trial with a Lawyer
present before they are sentenced.</p>
</li>
<li><p>If there are no Lawyers available, Police must allow the arrested to
go free after their jail time is up.</p>
</li>
<li><p>Sentences to those found guilty of crimes shall not exceed the
sentences laid out within The Law.</p>
</li>
<li><p>A person cannot be sentenced to a punishment for an individual crime
more than once.</p>
</li>
<li><p>If a person requests, they may choose to waive their right to a
Lawyer and defend themselves at trial.</p>
</li>
<li><p>Police must do their best to investigate suspects in order to
determine if a crime has been committed or not.</p>
</li>
<li><p>If someone is found innocent, they must be released from jail.</p>
</li>
<li><p>Crimes which have taken place more than 4 hours ago can no longer be
prosecuted.</p>
</li>
<li><p>If a person refuses or is unable to pay fines issued, they may be
arrested.</p>
</li>
<li><p>If a person refuses instructions which are laid out as part of a
punishment, they may be arrested.</p>
</li>
<li><p>It is not a crime to refuse instructions from police officers if
they are not given in connection with The Law.</p>
</li>
</ol>
<h2 id="-2-crimes-against-person">§2 : Crimes against Person</h2>
<ol>
<li><p>An attack is the act of causing harm to come to another person.</p>
</li>
<li><p>The act of killing another person is the crime of Murder.</p>
</li>
<li><p>It is not a crime to kill or attack another person, so long as it is
in self-defense. Self-defense is:</p>
<ol>
<li><p>In response to an attack or threat of attack,</p>
</li>
<li><p>Or: It is reasonably understood to be done in order to prevent a
crime,</p>
</li>
<li><p>So long as it is not provoked by the person claiming
self-defense.</p>
</li>
</ol>
</li>
</ol>
<!-- -->
<ol>
<li><p>The act of threatening another person for a criminal end is the
crime of Extortion.</p>
</li>
<li><p>The act of attacking another person without killing them is the
crime of Assault.</p>
</li>
<li><p>It is not a crime to attack somebody with their consent.</p>
</li>
<li><p>Trespassing is the act of being within another person’s property
without their consent.</p>
<ol>
<li><p>It is not a crime to attack a trespasser.</p>
</li>
<li><p>A person’s property is defined as an area enclosed by doors
which they own and which can be reasonably understood by a
potential trespasser as an area which they may be denied access
to.</p>
</li>
<li><p>Public spaces and service routes cannot be claimed as a person’s
property.</p>
</li>
</ol>
</li>
</ol>
<!-- -->
<ol>
<li><p>Confining a person against their will is considered the crime of
Kidnapping.</p>
<ol>
<li>It is not Kidnapping to instruct a person to remain within an
area, as long as it is possible for them to escape.</li>
</ol>
</li>
</ol>
<!-- -->
<ol>
<li><p>Killing a person with the intention of taking their money is the
crime of Robbery..</p>
</li>
<li><p>Usage of racial slurs or other offensive language repeatedly against
another person or group of persons is the crime of Harassment.</p>
</li>
</ol>
<h2 id="-3-crimes-against-property">§3 : Crimes against Property</h2>
<ol>
<li><p>Destruction of another person’s publicly accessible property is
considered the crime of Vandalism.</p>
</li>
<li><p>Destruction or taking of another person’s property which is not
publicly accessible is considered the crime of Burglary.</p>
</li>
<li><p>Placing objects or debris in another person’s property against their
will is considered Illegal Dumping. The dumped items must be
removed.</p>
</li>
<li><p>Placing objects or debris to deliberately obstruct another person’s
access to public property or to their property is considered the
crime of Obstruction of Traffic.</p>
</li>
<li><p>Deliberately purchasing doors within another person’s property in an
effort to spoil their use of it, against their will, is considered
the crime of Squatting. Ownership of the door must be removed.</p>
</li>
<li><p>Busting through another person’s doors without good reason is
considered the crime of Harassment.</p>
</li>
<li><p>Forcefully entering another person’s property in order to destroy
their property or take items of value is considered the crime of
Raiding.</p>
</li>
</ol>
<h2 id="-4-weapon-ownership">§4 : Weapon Ownership</h2>
<ol>
<li><p>It is a crime for a person who does not possess a gun license to
possess a firearm or explosive device.</p>
</li>
<li><p>It is a crime for a person to give a person who does not possess a
gun license a firearm.</p>
</li>
<li><p>It is not a crime for a person who does not possess a gun license to
briefly possess a firearm within the supervision of a licensed
individual.</p>
</li>
<li><p>It is not a crime to possess a melee weapon.</p>
</li>
<li><p>It is not a crime to possess ammunition.</p>
</li>
</ol>
<h2 id="-5-miscellaneous">§5 : Miscellaneous</h2>
<ol>
<li><p>It is considered the crime of Murder for Hire to solicit another
individual to commit murder.</p>
</li>
<li><p>It is considered the crime of Littering to leave items of any type
around in public without reason.</p>
</li>
<li><p>The possession of a Bitcoin Miner is illegal. Police are to destroy
contraband Bitcoin Miners.</p>
</li>
<li><p>It is illegal to escape or attempt to escape from prison.</p>
</li>
<li><p>Being party to a conspiracy to commit a crime is considered
Accessory to the crime, and is punishable.</p>
</li>
</ol>


]] )

    DarkRP.addF4MenuTab(tabName, HTML)
end
hook.Add("F4MenuTabs", "MyCustomF4MenuTab", createF4MenuTab)
