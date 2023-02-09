local m=27819077
local cm=_G["c"..m]
cm.name="五王-天启天炎"
cm.SetCard_fiveking=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.negcon)
	e3:SetCost(cm.negcost)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(cm.desreptg)
	e4:SetOperation(cm.desrepop)
	c:RegisterEffect(e4)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and not c:IsSetCard(0x48)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function cm.val(e,c)
	return c:GetEquipCount()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainDisablable(ev)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_DISABLE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:GetOriginalType()&TYPE_MONSTER~=0 and rc:IsAbleToChangeControler() then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_EQUIP)
		if rc:IsLocation(LOCATION_GRAVE) then
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,rc,1,0,0)
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	local rc=re:GetHandler()
	if not (rc:IsRelateToEffect(re) and rc:GetOriginalType()&TYPE_MONSTER~=0) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.Equip(tp,rc,c,false) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(cm.eqlimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(rc:GetBaseAttack())
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e2)
end
function cm.repfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return c:IsReason(REASON_EFFECT) and g:IsExists(cm.repfilter,1,nil)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,cm.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end