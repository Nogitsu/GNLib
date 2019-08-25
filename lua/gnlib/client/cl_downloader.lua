function GNLib.GetFile( filename )
  return "data/downloaded/" .. filename
end

function GNLib.CreateMaterial( filename, args )
  return Material( GNLib.GetFile(filename), args or "" )
end

function GNLib.PlayFile( filename )
  surface.PlaySound( "data/downloaded/" .. filename )
end

function GNLib.DownloadFromURL(url, filename, callback)
  if not isstring(url) or #url < 1 then return GNLib.Error("Invalid URL !") end
  if not isstring(filename) or #filename < 1 then return GNLib.Error("Invalid filename !", 2) end
  file.CreateDir("downloaded")

  if not file.Exists("downloaded/" .. filename, "DATA") then
    http.Fetch(url, function(data)
      file.Write("downloaded/" .. filename, data)

      if callback then
        callback( url, filename )
      end
    end)
  else
    if callback then
      callback( url, filename )
    end
  end

  return "data/downloaded/" .. filename
end
