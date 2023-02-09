--圣光宣告者
function c27819026.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c27819026.atkval)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27548199,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27548199)
	e2:SetCondition(c27819026.ovcon)  
	e2:SetCost(c27819026.ovcost)
	e2:SetTarget(c27819026.ovtg)
	e2:SetOperation(c27819026.ovop)
	c:RegisterEffect(e2)
end
function c27819026.atkval(e,c)
	return c:GetOverlayCount()*1000
end 
function c27819026.ovcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=re:GetHandler()
	return bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end 
function c27819026.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27819026.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c27819026.ovop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local rc=re:GetHandler()  
	local b1=true 
	local b2=rc:IsCanOverlay() 
	local op=0 
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27819026,0),aux.Stringid(27819026,1)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(27819026,0))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27819026,1))+1 
	end  
	if op==0 then 
	Duel.Destroy(rc,REASON_EFFECT)
	elseif op==1 then 
	Duel.Overlay(c,rc) 
	end 
end







