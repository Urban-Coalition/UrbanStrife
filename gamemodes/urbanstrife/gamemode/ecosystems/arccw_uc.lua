ECOSYSTEM = {}

ECOSYSTEM.Name = "Urban Coalition"

ECOSYSTEM.AttachmentType = ATTTYPE_ARCCW
ECOSYSTEM.PartialAttachments = {
}

function ECOSYSTEM:Check()
    return ArcCW ~= nil and ArcCW.UC ~= nil
end

function ECOSYSTEM:OnLoad()
end