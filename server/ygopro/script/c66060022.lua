--幻星集 圣杯国王
function c66060022.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,nil,2,2,c66060022.lcheck)
	c:EnableReviveLimit()
--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,66060022)
	e1:SetTarget(c66060022.thtg)
	e1:SetOperation(c66060022.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetCountLimit(1,66050022)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetTarget(c66060022.tetg)
	e2:SetOperation(c66060022.teop)
	c:RegisterEffect(e2)
--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(c66060022.splimit)
	c:RegisterEffect(e3)
end
function c66060022.splimit(e,se,sp,st)
	if not c then return false end
	return not c:IsSetCard(0x660)
end
function c66060022.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x660)
end
function c66060022.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x660) end
function c66060022.thfilter(c)
	return c:IsCode(66060030) or c:IsCode(66060026) and c:IsAbleToHand()
end
function c66060022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66060022.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66060022.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66060022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66060022.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c66060022.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
