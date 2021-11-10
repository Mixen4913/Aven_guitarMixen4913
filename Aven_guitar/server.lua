RegisterServerEvent('PlayMusicInstrument')
AddEventHandler('PlayMusicInstrument', function(maxDistance, soundFile, soundVolume)
  if GetConvar("onesync_enableInfinity", "false") == "true" then
    TriggerClientEvent('PlayMuSicInstrInf', -1, GetEntityCoords(GetPlayerPed(source)), maxDistance, soundFile, soundVolume)
  else
    TriggerClientEvent('PlayMuSicInstr', -1, source, maxDistance, soundFile, soundVolume)
  end
end)
