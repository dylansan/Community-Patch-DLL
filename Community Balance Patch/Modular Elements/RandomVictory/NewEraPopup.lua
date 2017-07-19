-------------------------------------------------
-- New Era Popup
-------------------------------------------------

local m_PopupInfo = nil;
local lastBackgroundImage = "DiploVictory.dds"

-------------------------------------------------
-- On Popup
-------------------------------------------------
function OnPopup( popupInfo )

	if( popupInfo.Type ~= ButtonPopupTypes.BUTTONPOPUP_MODDER_4 ) then
		return;
	end

	m_PopupInfo = popupInfo;

    local iValue = popupInfo.Data1;

	if(iValue == 1) then
		Controls.DescriptionLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_TYPE_DIPLO");
		lastBackgroundImage = "DiploVictory.dds";
		Controls.TitleLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_SPLASH");
	elseif(iValue == 2) then
		Controls.DescriptionLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_TYPE_CULTURE");
		lastBackgroundImage = "CultureVictory.dds";
		Controls.TitleLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_SPLASH");
	elseif(iValue == 3) then
		Controls.DescriptionLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_TYPE_SPACERACE");
		lastBackgroundImage = "SpaceRaceVictory.dds";
		Controls.TitleLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_SPLASH");
	else
		Controls.DescriptionLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_TYPE_CONQUEST");
		lastBackgroundImage = "ConquestVictory.dds";
		Controls.TitleLabel:LocalizeAndSetText("TXT_KEY_POP_WORLD_VICTORY_SPLASH");
	end

	Controls.EraImage:SetTexture(lastBackgroundImage);
	
	UIManager:QueuePopup( ContextPtr, PopupPriority.NewEraPopup );
end
Events.SerialEventGameMessagePopup.Add( OnPopup );


----------------------------------------------------------------        
-- Input processing
----------------------------------------------------------------        

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnClose()
    UIManager:DequeuePopup( ContextPtr );
    Controls.EraImage:UnloadTexture();
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnClose);

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
            OnClose();
            return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function ShowHideHandler( bIsHide, bInitState )

    if( not bInitState ) then
       Controls.EraImage:UnloadTexture();
       if( not bIsHide ) then
        	Controls.EraImage:SetTexture(lastBackgroundImage);
        	UI.incTurnTimerSemaphore();
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
            UI.decTurnTimerSemaphore();
            Events.SerialEventGameMessagePopupProcessed.CallImmediate(ButtonPopupTypes.BUTTONPOPUP_MODDER_4, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnClose);
