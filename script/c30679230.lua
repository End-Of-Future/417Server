--自律人理·全矢量展开·超引力破坏群
local m=30679230
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,30679230),LOCATION_MZONE)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,12,5,cm.ovfilter,aux.Stringid(m,0),99,cm.xyzop)
	--XYZ SUM
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0) 
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--Overlay
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.recon)
	e2:SetOperation(cm.reop1)
	c:RegisterEffect(e2)
	--Overlay
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	e3:SetTargetRange(1,1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Overlay
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e30:SetCode(EVENT_LEAVE_FIELD_P)
	e30:SetRange(LOCATION_MZONE)
	e30:SetCondition(cm.recon)
	e30:SetOperation(cm.reop2)
	c:RegisterEffect(e30)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
	--atk limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e6:SetValue(cm.atklimit)
	c:RegisterEffect(e6)
	--actlimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,1)
	e8:SetCondition(cm.xyzcon1)
	e8:SetValue(cm.actlimit)
	c:RegisterEffect(e8)
	--immune
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(cm.xyzcon2)
	e9:SetValue(cm.efilter)
	c:RegisterEffect(e9)
	--atk
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_UPDATE_ATTACK)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(cm.xyzcon3)
	e10:SetValue(cm.atkupval)
	c:RegisterEffect(e10)
end
function cm.splimit(e,se,sp,st)
	if st&SUMMON_TYPE_XYZ~=0 then return not se or not se:IsHasType(EFFECT_TYPE_ACTIONS)
	else
		return true
	end
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(30678590)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.filter(c)
	return c:IsCanOverlay()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #g>=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if #g>=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ)
end
function cm.reop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	for tc in aux.Next(eg) do
		if tc:IsLocation(LOCATION_GRAVE) then g:AddCard(tc) end
	end
	Duel.Overlay(e:GetHandler(),g)
end
function cm.reop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_XYZ) then
			local g=tc:GetOverlayGroup()
			if g and #g>0 then
				Duel.Overlay(e:GetHandler(),g)
				Duel.BreakEffect()
				Duel.Overlay(e:GetHandler(),tc)
			end
		end
	end
end
function cm.atkfilter(c)
	return c:GetAttack()>=0
end
function cm.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function cm.atklimit(e,c)
	return c~=e:GetHandler()
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.adval(e,c)
	local vg=Duel.GetMatchingGroup(cm.vfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sum=vg:GetSum(Card.GetAttack)
	return sum
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function cm.xyzcon1(e)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=7
end
function cm.actlimit(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.xyzcon2(e)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=10
end
function cm.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xc13)
end
function cm.xyzcon3(e)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=5
end
function cm.atkupval(e,c)
	return c:GetOverlayCount()*1000
end