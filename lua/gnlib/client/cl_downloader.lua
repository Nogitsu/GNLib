function GNLib.GetFile(filename)
  return "data/downloaded/" .. filename
end

function GNLib.DownloadFromURL(url, filename)
  if not isstring(url) or #url < 1 then return GNLib.Error("Invalid URL !") end
  if not isstring(filename) or #filename < 1 then return GNLib.Error("Invalid filename !", 2) end
  file.CreateDir("downloaded")

  if not file.Exists("downloaded/" .. filename, "DATA") then
    http.Fetch(url, function(data)
      file.Write("downloaded/" .. filename, data)
    end)
  end

  return "data/downloaded/" .. filename
end
