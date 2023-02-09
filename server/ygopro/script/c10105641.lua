function c10105641.initial_effect(c)
	  --code
	aux.EnableChangeCode(c,70095154,LOCATION_MZONE+LOCATION_GRAVE)
 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105641,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10105641)
	e1:SetTarget(c10105641.target)
	e1:SetOperation(c10105641.operation)
	c:RegisterEffect(e1)
    	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10105641.hspcon)
	e2:SetTarget(c10105641.hsptg)
	e2:SetOperation(c10105641.hspop)
	c:RegisterEffect(e2)
    	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105641,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101056410)
	e3:SetTarget(c10105641.tgtg)
	e3:SetOperation(c10105641.tgop)
	c:RegisterEffect(e3)
end
function c10105641.filter(c)
	return c:IsSetCard(0x1093,0x4093) and c:IsAbleToHand()
end
function c10105641.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105641.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105641.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10105641.rfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsSetCard(0x4093,0x1093) and c:IsLevelAbove(1)
end
function c10105641.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,5)
		and Duel.GetMZoneCount(tp,g)>0 and Duel.CheckReleaseGroupEx(tp,aux.IsInGroup,#g,nil,g)
end
function c10105641.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,true):Filter(c10105641.rfilter,c,tp)
	return rg:CheckSubGroup(c10105641.fselect,1,rg:GetCount(),tp)
end
function c10105641.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,true):Filter(c10105641.rfilter,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c10105641.fselect,true,1,rg:GetCount(),tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c10105641.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
end
function c10105641.tgfilter(c,tp)
	return c:IsSetCard(0x93) and c:IsType(TYPE_MONSTER)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode()) and c:IsAbleToGrave()
end
function c10105641.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105641.tgfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c10105641.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10105641.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end