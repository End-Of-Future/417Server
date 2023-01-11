--自律部队·武装结合体
local m=30679250
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc13),2,2,nil)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc13)
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetOriginalAttribute(),c:GetOriginalRace(),tp)
end
function cm.eqfilter(c,att,race,tp)
	return c:IsType(TYPE_MONSTER) and (c:GetOriginalAttribute()==att or c:GetOriginalRace()==race)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc:GetOriginalAttribute(),tc:GetOriginalRace(),tp)
		local sc=g:GetFirst()
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(cm.eqlimit)
		sc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
