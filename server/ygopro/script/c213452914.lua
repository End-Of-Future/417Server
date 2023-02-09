--德拉科尼亚的征召命令
function c213452914.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,213452914+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c213452914.cost)
	e1:SetTarget(c213452914.thtg)
	e1:SetOperation(c213452914.thop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(213452914,ACTIVITY_SPSUMMON,c213452914.counterfi)
end
function c213452914.counterfi(c)
	return not c:IsType(TYPE_EFFECT)
end
function c213452914.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(213452914,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c213452914.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c213452914.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end
function c213452914.thfi(c)
	return c:IsType(TYPE_MONSTER+TYPE_PENDULUM) and c:IsAbleToHand()
end
function c213452914.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213452914.thfi,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,2,tp,LOCATION_DECK)
end
function c213452914.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c213452914.thfi,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
