--五王的约定
function c27819062.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27819062+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27819062.target)
	e1:SetOperation(c27819062.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819062,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c27819062.matcon)
	e2:SetTarget(c27819062.mattg)
	e2:SetOperation(c27819062.matop)
	c:RegisterEffect(e2)
end
c27819062.SetCard_fiveking=true
function c27819062.chkfilter(c,tp)
	return c.SetCard_fiveking and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c27819062.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c27819062.thfilter(c,att)
	return c.SetCard_fiveking and c:IsAttribute(att) and c:IsAbleToHand()
end
function c27819062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819062.chkfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27819062.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,c27819062.chkfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if rc then
		local att=rc:GetAttribute()
		 e:SetLabel(rc)
		 e:SetLabelObject(e)
		Duel.ConfirmCards(1-tp,rc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c27819062.thfilter,tp,LOCATION_DECK,0,1,1,nil,att)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c27819062.cfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end
function c27819062.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819062.cfilter,1,nil,e)
end
function c27819062.tgfilter(c,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c27819062.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c27819062.tgfilter(chkc,eg) end
	if chk==0 then return Duel.IsExistingTarget(c27819062.tgfilter,tp,LOCATION_MZONE,0,1,nil,eg)
		and e:GetHandler():IsCanOverlay() end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c27819062.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c27819062.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
